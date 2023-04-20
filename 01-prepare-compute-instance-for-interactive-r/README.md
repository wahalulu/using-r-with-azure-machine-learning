# Create a Compute Instance and prepare it to use R with Visual Studio Code for an interactive session

1. Create a Compute Instance through the Azure Machine Learning studio. **Note: that the name of the Compute Instance needs to be unique across the region for all customers.**
1. After you create the Compute Instance, click on it and open the Terminal (online)
1. Clone this repository: `https://github.com/wahalulu/using-r-with-azure-machine-learning.git`
1. Navigate to the _Notebooks_ tab on the left
1. Using the graphical file manager, navigate to the directory where you cloned this repo
1. Find and hover over the file called `vscode-setup-interactive.sh` within the `01-prepare-compute-instance-for-interactive-r` directory, and click on the `...` on the right, and select _Run script in terminal_
1. After the script finishes running, you may close the terminal
1. Navigate to the _Compute_ tab on the left
1. Find your Compute Instance and click on _VS Code (Desktop)_ to open Visual Studio Code on your local machine and create a remote connection to the Compute Instance
    - This installs the _VS Code server_ extension on the Compute Instance
    - The remote connection gets set up
1. Open a Terminal window in Visual Studio Code and continue doing all the next steps within the terminal.
