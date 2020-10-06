<#
.SYNOPSIS
This script creates prerequisite file for module 3 and later from the DP-200 training.

.NOTES
Containers & files:
\data\DimDate2.txt      required for Module 5: SQL and Synapse (DW)
\logs\preferences.json  required for Module 3: Databricks
\phonecalls             required for Module 6: stream analytics
#>


$rgName = 'dp200'
$location = 'westeurope'
$saName = 'test'# "dp200x$(Get-Random)"
$containers = 'data', 'logs', 'phonecalls'
$file1 = 'https://raw.githubusercontent.com/MicrosoftLearning/DP-200-Implementing-an-Azure-Data-Solution/master/Labfiles/Starter/DP-200.2/Static%20files/DimDate2.txt'
$file2 = 'https://raw.githubusercontent.com/MicrosoftLearning/DP-200-Implementing-an-Azure-Data-Solution/master/Labfiles/Starter/DP-200.2/logs/preferences.json'

New-AzResourceGroup -Location $location -Name $rgName

# Check StorageAccountNameAvailability
$available = Get-AzStorageAccountNameAvailability -Name $saName

if ($available.NameAvailable) {
    # Create storage account, from lab: Std/V2/RA_GRS/Hot/HIERARCHICAL
    $s = New-AzStorageAccount -ResourceGroupName $rgName -Name $saName -SkuName Standard_LRS -Location $location -EnableHierarchicalNamespace $true

    # create containers
    $containers | ForEach-Object { New-AzStorageContainer -Name $_ -Context $s.Context }

    # create files
    Start-AzStorageBlobCopy -DestContext $s.Context -DestContainer 'data' -DestBlob (Split-Path $file1 -Leaf) -AbsoluteUri $file1
    Start-AzStorageBlobCopy -DestContext $s.Context -DestContainer 'logs' -DestBlob (Split-Path $file2 -Leaf) -AbsoluteUri $file2

}
