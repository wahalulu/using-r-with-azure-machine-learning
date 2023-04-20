# Create custom image for model deployment in Azure Container Registry

In this step, you will create a new Docker image and register it directly in the Azure Container Registry. This is slightly different than creating the Environment you created in step 04. Here you are not creating an Environment, just an image.

It's worth noting that an Environment also has an associated image in the Azure Container Registry. However, for R, you need to create and use the image directly for deployment. This is not the case for job runs.

1. In the terminal, change directories to `07-create-acr-image-for-deployment`
1. Run the following command: `bash build-container-for-deployment-in-acr.sh`. This will kick off the creation of the image and can take several minutes. 
1. When the bash script finishes, you will see an output printed on screen that looks something like: `xxxxxx.azurecr.io/r-plumber-timeseries`. Make a note of this, you will need this piece of information for step 09.

