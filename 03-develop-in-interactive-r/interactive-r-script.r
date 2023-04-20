# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

## NOTES

# Code adapted, modified and optimized from the forecasting example
# https://microsoft.github.io/forecasting/examples/grocery_sales/
# https://github.com/microsoft/forecasting
# accessed 11/14/2022

# install additional libraries in a personal library
install.packages(c("tsibble", "fable", "feasts", "urca"))

# read tabular data from a registered dataset using reticulate and azureml-fsspec

# load reticulate and set the proper conda environment
library(reticulate)
use_condaenv("azureml_py310_sdkv2")

## The following code gets the Azure Machine Learning client via the Python SDK using reticulate
## and retrieves the URI for the registered dataset

get_azureml_client_code <- "from azure.identity import DefaultAzureCredential
from azure.ai.ml import MLClient
credential = DefaultAzureCredential()
ml_client = MLClient.from_config(credential=credential)"
py_run_string(get_azureml_client_code)

get_data_asset_path_code <- "my_name = 'orangejuice-sales'
my_version = '1'
data_asset = ml_client.data.get(name=my_name, version=my_version)
data_uri = data_asset.path"
py_run_string(get_data_asset_path_code)
print(paste("URI path is", py$data_uri))

## Now we use Pandas to read in a dataframe
pd <- import("pandas")
oj_sales_read <- pd$read_csv(py$data_uri) |>
    janitor::clean_names()

head(oj_sales_read)

## From here on you can write regular R code and use R packages.

library(tidyverse)
library(tsibble)
library(fable)

if (!dir.exists("./outputs")) {
    dir.create("./outputs")
}

# This value is hardcoded for the timeseries

START_DATE <- as.Date("1989-09-14")

## Data prep of the full dataset

oj_sales <- oj_sales_read |>
    # complete the missing combinations
    tidyr::complete(store, brand, week) |>
    # create the actual week based on start date and # of weeks passed
    mutate(yr_wk = tsibble::yearweek(START_DATE + week * 7)) |>
    select(-week) |>
    # convert to tsibble
    as_tsibble(index = yr_wk, key = c(store, brand))

## Select the store and brand based on the job parameter
sales_for_store_brand <- oj_sales |>
    filter(store == 2, brand == 1)

# All stores have the same start week (1990 W25) and end week (1992 W41).
# For training, use 100 weeks (1992 W18)

# The model function in fabletools can fit multiple models
# out of the box. Here we are creating four models.

fit <- sales_for_store_brand |>
    filter(yr_wk <= yearweek("1992 W18")) |>
    model(
        mean = MEAN(logmove),
        naive = NAIVE(logmove),
        drift = RW(logmove ~ drift()),
        arima = ARIMA(logmove ~ pdq() + PDQ(0, 0, 0))
    )

# Forecast out 10 weeks
fcast <- forecast(fit, h = 10)

# Evaluate the metrics for each model (one set of metrics
# per modeltype/store/brand)
metrics <- accuracy(fcast, oj_sales)

metrics

# create a plot and save it to output
forecast_plot <-
    autoplot(fcast) +
    geom_line(
        data = sales_for_store_brand |>
            filter(yr_wk <= yearweek("1992 W18")),
        aes(x = yr_wk, y = logmove)
    )

forecast_plot

ggsave(
    forecast_plot,
    filename = "./outputs/forecast-plot.png",
    units = "px",
    dpi = 100,
    width = 800,
    height = 600
)


# create a tibble with one row per model and all re-arranged artifacts
# (tidy info, metrics and forecast), plus tibbles for logging:
#


all_model_data <-
    fit |>
    # as_tibble() |>
    select(-c(store, brand)) |>
    pivot_longer(
        cols = everything(),
        names_to = "model_name",
        values_to = "model_object"
    ) |>
    mutate(tidy_model = map(model_object, tidy)) |>
    inner_join(
        metrics |>
            select(-c(store, brand)) |>
            nest(metrics = -c(.model)),
        by = c("model_name" = ".model")
    ) |>
    inner_join(
        fcast |>
            as_tibble() |>
            select(-c(store, brand)) |>
            #      group_by(.model) |>
            group_nest(.model, .key = "prediction"),
        by = c("model_name" = ".model")
    ) |>
    mutate(
        metrics_tbl = map(metrics, function(m) {
            m |>
                select(-c(.type)) |>
                pivot_longer(everything(),
                    names_to = "key"
                ) |>
                mutate(
                    step = 0,
                    timestamp = as.integer(Sys.time())
                )
        }),
        params_tbl = map(tidy_model, function(tm) {
            tm |>
                pivot_longer(-term) |>
                unite("key", c(term, name))
        }),
        tag_tbl = map(model_name, function(n) {
            tibble(key = "model", value = n)
        })
    )


write_rds(all_model_data,
    file = "outputs/all-models-tibble.rds"
)
