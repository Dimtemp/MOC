This script will remove selected resource groups from your subscription

```powershell

# Use Windows PowerShell or PowerShell core. This will not work from the cloud shell.

Get-AzResourceGroup |
Out-GridView -Title 'select resource groups to remove' -OutputMode Multiple |
Remove-AzResourceGroup -force

# Get-AzResourceGroup | ogv -output Multiple | foreach { Remove-AzResourceGroup -Name $_.ResourceGroupName -force }

```
