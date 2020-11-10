# use Connect-AzAccount or run this in a cloud shell

# new storage account (LRS)
$resourceGroup = 'ML-M04'
$location = 'westeurope'
$accountName = "m04$(Get-Random)"
$SkuName = 'Standard_LRS'
$containerName = 'aml-data'

New-AzResourceGroup -Name $resourceGroup -Location $location

$storageAccount = New-AzStorageAccount -ResourceGroupName $resourceGroup -Name $accountName -Location $location -SkuName $SkuName -Kind StorageV2
$ctx = $storageAccount.Context

New-AzStorageContainer -Name $containerName -Context $ctx -Permission blob

# Access keys: copy key
$key = Get-AzStorageAccountKey -ResourceGroupName $resourceGroup -Name $accountName
$key[0].Value | Clip
Write-Host 'The storage account key is available in your clipboard'
