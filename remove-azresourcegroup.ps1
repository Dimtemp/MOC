# This script will remove selected resource groups from your subscription
# Use Windows PowerShell or PowerShell core. This will not work from the cloud shell.

Get-AzResourceGroup |
Out-GridView -Title 'select resource groups to remove' -OutputMode Multiple |
Remove-AzResourceGroup -force
