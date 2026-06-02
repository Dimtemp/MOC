# Demo script to create an Azure SQL DB

# variables
$RGName       = 'sqldb'
$ServerName   = 'sql9876'
$Location     = 'west europe'
$DatabaseName = 'Sales'

# login to Azure
Connect-AzAccount

# determine Microsoft.Sql locations
Get-AzResourceProvider -ListAvailable |
    Where-Object { $_.ProviderNamespace -eq 'Microsoft.Sql' } |
    Select-Object -ExpandProperty Locations

# create resource group
New-AzResourceGroup -Name $RGName -Location $Location

# create server, might take a while
$cred = Get-Credential
New-AzSqlServer -ResourceGroupName $RGName -ServerName $ServerName -Location $Location -SqlAdministratorCredentials $cred # -ServerVersion '12.0'

# determine client ip address
$ip = Invoke-RestMethod http://ipinfo.io/json | Select-Object -expand ip
$ip

# specify client ip address as allowed
New-AzSqlServerFirewallRule -ResourceGroupName $RGName -ServerName $ServerName -FirewallRuleName 'myFirewallRule' -StartIpAddress $ip -EndIpAddress $ip

# create new database
New-AzSqlDatabase -ResourceGroupName $RGName -ServerName $ServerName -DatabaseName $DatabaseName -Edition Standard -RequestedServiceObjectiveName 'S1'

# optional
Remove-AzSqlDatabase -DatabaseName $DatabaseName -ServerName $ServerName -ResourceGroupName $RGName

# remove sql server including databases
Remove-AzSqlServer -ServerName $ServerName -ResourceGroupName $RGName
