# Mcd79TwitterSearchConnector
Sample for creating Microsoft Search custom indexes

## Setup 
The code in this repo includes the individual Logic Apps as well as the ARM Template for setting up the full resource group. At this point, there is a lot of manual work needed to get this working but it will be updated shortly.

## Register an app in Azure portal

In this step you'll register an application in the Azure AD admin center. This is necessary to authenticate the application to make calls to the Microsoft Graph indexing API.

1. Go to the [Azure Active Directory admin center](https://aad.portal.azure.com/) and sign in with an administrator account.
1. Select **Azure Active Directory** in the left-hand pane, then select **App registrations** under **Manage**.
1. Select **New registration**.
1. Complete the **Register an application** form with the following values, then select **Register**.

    - **Name:** `Parts Inventory Connector`
    - **Supported account types:** `Accounts in this organizational directory only (Microsoft only - Single tenant)`
    - **Redirect URI:** Leave blank

1. On the **Parts Inventory Connector** page, copy the value of **Application (client) ID**, you'll need it in the next section.
1. Copy the value of **Directory (tenant) ID**, you'll need it in the next section.
1. Select **API Permissions** under **Manage**.
1. Select **Add a permission**, then select **Microsoft Graph**.
1. Select **Application permissions**, then select the **ExternalItem.ReadWrite.All** permission. Select **Add permissions**.
1. Select **Grant admin consent for {TENANT}**, then select **Yes** when prompted.
1. Select **Certificates & secrets** under **Manage**, then select **New client secret**.
1. Enter a description and choose an expiration time for the secret, then select **Add**.
1. Copy the new secret, you'll need it in the next section.

## Configuring the Logic Apps
Each of the Logic Apps requires the Client ID, Tenant ID and Client Secret to be used in the HTTP actions.
