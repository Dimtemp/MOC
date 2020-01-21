# This script will remove selected resource groups from your subscription
# Use Windows PowerShell or PowerShell core. This will not work from the cloud shell.
# In the cloud shell this command will remove ALL resource groups. Use with caution:  Get-AzResourceGroup | Remove-AzResourceGroup

Get-AzResourceGroup |
Out-GridView -Title 'select resource groups to remove' -OutputMode Multiple |
Remove-AzResourceGroup -force
