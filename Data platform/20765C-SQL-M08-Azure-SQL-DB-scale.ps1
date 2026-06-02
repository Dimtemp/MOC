# scale up and down azure sql db
# Get-AzureRmSqlServer

# downsize at the end of the day
Set-AzureRmSqlDatabase -DatabaseName sales -ServerName vrijdagvm -Edition Basic -ResourceGroupName vrijdagsqlvm

# size up at the start of the day
Set-AzureRmSqlDatabase -DatabaseName sales -ServerName vrijdagvm -Edition Standard -ResourceGroupName vrijdagsqlvm -RequestedServiceObjectiveName 'S2'
