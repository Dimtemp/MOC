Get-AzResourceGroup |
Out-GridView -Titel 'select resource groups to remove' -OutputMode Multiple |
Remove-AzResourceGroup
