#!/bin/bash

set -e

# As of 4/18/2023, azureml-fsspec is already available on new compute instances in the azureml_py310_sdkv2 environment
# As of 04/18/2023 the reticulate version is 1.28 on new compute instances

# The following installs the R packages languageserver and httpgd in the /usr/local/lib/R/site-library path (along with other pre-installed pacakges). This allows Visual Studio Code work with R on the compute instance using a remote connection.

# You may install additional packages here which will be installed in the /usr/local/lib/R/site-library path, or you can install packages interactively in a personal library path.

sudo R --vanilla <<EOF
install.packages(c('languageserver', 'httpgd'), repos='http://cran.us.r-project.org')
q()
EOF
