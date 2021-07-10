# Remove specified resource groups from your Azure subscription

### Use PowerShell v3+. This will not work from the cloud shell or non-Windows PowerShell versions.

# In the cloud shell this command will remove ALL resource groups. Use with caution!
```powershell
Get-AzResourceGroup | Remove-AzResourceGroup
```

```powershell
Get-AzResourceGroup |
Out-GridView -Title 'select resource groups to remove' -OutputMode Multiple |
Remove-AzResourceGroup -force
```powershell

# Optionally install Microsoft.PowerShell.ConsoleGuiTools on non-Windows operating systems:
```powershell
Install-Module Microsoft.PowerShell.ConsoleGuiTools
Get-AzResourceGroup |
Out-ConsoleGridView -Title 'select resource groups to remove' -OutputMode Multiple |
Remove-AzResourceGroup -force
```
