# Remove Azure Active Directory
## Caution! Only to be performed when you're absolutely sure what you're doing!
1. Azure Portal
    - Verify adsync account: is it Global admin?
    - If not: make it Global Admin or create new Global Admin
1. Windows computer
    - Start PowerShell
    - install-module msonline
    - Connect-MsolService
    - Get-MsolDirSyncConfiguration
    - Set-MSOLDirSyncEnabled -EnableDirSync $false
1. Open a web browser
    - Log on to https://admin.microsoft.com
    - Select Subscriptions
    - Delete any subscriptions
1. Log on to the Azure Portal
    - Open the Azure Active Directory blade
    - Click ***Delete directory***

More info:
https://support.microsoft.com/en-us/help/2619062/you-can-t-manage-or-remove-objects-that-were-synchronized-through-the
