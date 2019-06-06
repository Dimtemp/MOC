# Remove AAD
1. Azure Portal
  1. adsync account: verify: is it Global admin?
  1. If not: create new global admin
1. Windows computer
  1. Start PowerShell
    1. install-module msonline
    1. Connect-MsolService   # eventueel update your password als dit eerste login is
    1. Get-MsolDirSyncConfiguration
    1. Set-MSOLDirSyncEnabled -EnableDirSync $false
1. Open a web browser
  1. Log on to admin.microsoft.com
  1. Subscriptions
  1. Delete any subscriptions
1. Log on to Azure Portal to Remove Azure Active Directory

More info:
https://support.microsoft.com/en-us/help/2619062/you-can-t-manage-or-remove-objects-that-were-synchronized-through-the
