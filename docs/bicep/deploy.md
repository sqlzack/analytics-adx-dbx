## Deploy Resources
___
1) Download and [install Visual Studio Code](https://code.visualstudio.com/). 
2) Ensure you have the [Bicep Extension for VSCode](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep) installed.
3) Ensure you have the [Azure Account Extension for VSCode](https://marketplace.visualstudio.com/items?itemName=ms-vscode.azure-account) installed.
4) Clone the repository you're currently viewing into VS Code using [this guide](https://learn.microsoft.com/en-us/azure/developer/javascript/how-to/with-visual-studio-code/clone-github-repository?tabs=create-repo-command-palette%2Cinitialize-repo-activity-bar%2Ccreate-branch-command-palette%2Ccommit-changes-command-palette%2Cpush-command-palette#clone-repository).
5) Locate the [deployall.parameters.json](../../deploy/deployall.parameters.json) file in your local repository and update the parameters accordingly. (If you'd like a description of what each Parameter does, locate the [deployall.bicep](../../deploy/deployall.bicep) script which contains the descriptions.)