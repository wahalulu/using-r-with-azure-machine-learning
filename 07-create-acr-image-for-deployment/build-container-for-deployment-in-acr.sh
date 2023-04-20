#!/bin/bash
WORKSPACE=$(az config get --query "defaults[?name == 'workspace'].value" -o tsv)
ACR_NAME=$(az ml workspace show -n $WORKSPACE --query container_registry -o tsv | cut -d'/' -f9-)
IMAGE_TAG=${ACR_NAME}.azurecr.io/r-plumber-timeseries

az acr build ./docker-context -t $IMAGE_TAG -r $ACR_NAME

echo $IMAGE_TAG