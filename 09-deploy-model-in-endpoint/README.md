# Create model deployment associated with the Endpoint you created

1. In the terminal, change directories to `09-deploy-model-in-endpoint`
1. In VSCode open the `deployment.yml` file
1. In line 10, change `<ACR-IMAGE>` to the value of the image you created in step 07 and save. The full name of the image will be something like: `xxxxxx.azurecr.io/r-plumber-timeseries`
1. Run the following command: `az ml online-deployment create -f deployment.yml --all-traffic --skip-script-validation --no-wait`
1. Go to the Azure Machine Learning Studio (web) to see the status of the deployment and for testing.

