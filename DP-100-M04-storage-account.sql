# new storage account (LRS)
$resourceGroup = 'ML-M04'
$location = 'westeurope'
$accountName = "ML04$(Get-Random)"
$SkuName = 'Standard_LRS'

New-AzResourceGroup -Name $resourceGroup -Location $location

New-AzStorageAccount -ResourceGroupName $resourceGroup -Name $accountName -Location $location -SkuName $SkuName -Kind StorageV2

# New container: aml-data

# Access keys: copy key
