# Remove AAD
1. Azure Portal
  - adsync account: verify: is it Global admin?
  - If not: create new global admin
1. Windows computer
  1. Start PowerShell
    - install-module msonline
    - Connect-MsolService   # eventueel update your password als dit eerste login is
    - Get-MsolDirSyncConfiguration
    - Set-MSOLDirSyncEnabled -EnableDirSync $false
1. Open a web browser
  - Log on to admin.microsoft.com
  - Subscriptions
  - Delete any subscriptions
1. Log on to Azure Portal to Remove Azure Active Directory

More info:
https://support.microsoft.com/en-us/help/2619062/you-can-t-manage-or-remove-objects-that-were-synchronized-through-the
