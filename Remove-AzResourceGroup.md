# Remove specified resource groups from your Azure subscription

Use this command when you're running PowerShell v3+. This will not work from the cloud shell or non-Windows PowerShell versions.
```powershell
Get-AzResourceGroup |
Out-GridView -Title 'select resource groups to remove' -OutputMode Multiple |
Remove-AzResourceGroup -force
```

Use this command from the cloud shell. It will remove ALL resource groups. Use with caution!
```powershell
Get-AzResourceGroup | Remove-AzResourceGroup
```


Optionally install Microsoft.PowerShell.ConsoleGuiTools. Very nice semi-GUI. Also runs on non-Windows operating systems:
```powershell
Install-Module Microsoft.PowerShell.ConsoleGuiTools
Get-AzResourceGroup |
Out-ConsoleGridView -Title 'select resource groups to remove' -OutputMode Multiple |
Remove-AzResourceGroup -force
```
