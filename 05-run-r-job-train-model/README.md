# Run an R training job

Now that you have created the environment for your job and that you've modified your R script to run in production as explained [in this guide](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-r-modify-script-for-production?view=azureml-api-2), you will now run a job.

1. In the terminal, change directories to `05-run-r-job-train-model` directory
1. In VSCode, open the `r-job.yml` file
1. In line 17, change `<COMPUTE-INSTANCE-OR-CLUSTER>` to the name of the Compute Instance you created in step 01 and save the file. In this example the job will run on a container on the Compute Instance, but you can also run a job on a Compute Cluster
1. Run the following command to kick-off the job: `az ml job create -f r-job.yml`
1. Go back to Azure Machine Learning Studio (web) and you'll see the job

