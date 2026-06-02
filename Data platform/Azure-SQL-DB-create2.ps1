# Connect-AzAccount
# The SubscriptionId in which to create these objects
$SubscriptionId = ''

# Set the resource group name and location for your server
$resourceGroupName = "myResourceGroup-$(Get-Random)"
$location = "westeurope"

# Set server name - the logical server name has to be unique
$serverName = "sql$(Get-Random)"

$databaseName = 'Sales'


# Set an admin login and password for your server
$adminSqlLogin = 'Dimitri'
$password = 'Pa55w.rd'

# run

# prepare credentials
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $adminSqlLogin, $securePassword


# Set subscription 
Set-AzContext -SubscriptionId $subscriptionId 

# Create a resource group
$resourceGroup = New-AzResourceGroup -Name $resourceGroupName -Location $location

# Create a server with a system wide unique server name
$server = New-AzSqlServer -ResourceGroupName $resourceGroupName -ServerName $serverName -Location $location -SqlAdministratorCredentials $cred

# Create a server firewall rule that allows access from the specified IP range
# $serverFirewallRule = New-AzSqlServerFirewallRule -ResourceGroupName $resourceGroupName -ServerName $serverName -FirewallRuleName 'Allowed' -StartIpAddress '0.0.0.0' -EndIpAddress '0.0.0.0'

$database = New-AzSqlDatabase -ResourceGroupName $resourceGroupName -ServerName $serverName -DatabaseName $databaseName -RequestedServiceObjectiveName 'Basic' -SampleName 'AdventureWorksLT'

