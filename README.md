# Mcd79TwitterSearchConnector
Sample for creating Microsoft Search custom indexes

## Setup 
The code in this repo includes the individual Logic Apps as well as the ARM Template for setting up the full resource group. The steps below detail how to set up using the Azure Cloud Shell. Manual details will be added later.

- Connect to the Azure Portal
- Open Azure Cloud Shell and select Bash
- Install NVM using commands below (due to [issue with version of Node used](https://github.com/pnp/cli-microsoft365/issues/2017))

`curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh
`export NVM_DIR="$HOME/.nvm"
`[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
`[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
- Install the latest LTS Node version and set it as active
`nvm install --lts
`nvm use --lts

- Login with CLI for Microsoft 365 using your [preferred option](https://pnp.github.io/cli-microsoft365/user-guide/connecting-office-365/#log-in-using-the-default-device-code-flow)
- Add an app registration using [app add](https://pnp.github.io/cli-microsoft365/cmd/aad/app/app-add/) and store the results in variables
`newApp=$(m365 aad app add -n S4MSCTwitter --multitenant --withSecret --apisApplication 'https://graph.microsoft.com/ExternalItem.ReadWrite.All' -o json)
`newAppId=`echo $newApp | jq -r '.appId'`
`newTenantId=`echo $newApp | jq -r '.tenantId'`
`newSecret=`echo $newApp | jq -r '.secret'`
- Create a new Resource Group
`az group create --name S4MSCTwitter --location uksouth
- Deploy the Logic Apps using ARM
`az deployment group create --name LaDeployment --resource-group S4MSCTwitter --template-uri "https://raw.githubusercontent.com/kevmcdonk/S4MSC-Twitter/main/template.json" --parameters connections_twitter_name=S4MSCTwitter region=uksouth tenantId=$newTenantId clientId=$newAppId secret=$newSecret
- Go to Azure AD in the portal and consent the API permission
- Go to the Resource Group and select the Twitter connector
- Click on Edit API Connection and then Authorize
- Run the Setup Logic App
- Confirm in the Search Settings that an index has been set up
