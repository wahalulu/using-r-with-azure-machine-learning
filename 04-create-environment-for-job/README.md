# Create an environment for running your R job in a Docker container

In this step, you will create a Docker container with a custom image which has a required set of Python and R libraries so you can run jobs in Azure Machine Learning.

In the `docker-context/Dockerfile` you will see these.

If you need specific R packages for your job, you should specify them in the Dockerfile and have them installed.

1. In the terminal, change directiories to `04-create-environment-for-job`
1. Run the following command: `az ml environment create -f r-job-environment.yml`

This command will kick-off the creation of the environment and can take some time depending on how many packages you are installing.