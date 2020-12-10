# Azure Architect open lab 2

In this lab you're going to create a logic app that monitors a storage account. As soon as a file is added to the storage account, it will be picked up by the logic app and written to a Service Bus queue.

## Create resources
Create three new resources using the Azure portal:
  1. Storage account
  1. Logic App
1. Service Bus

Optionally, you can create the three resources using this PowerShell command:
```
$Location = 'westeurope'
$ResourceGroupName = 'AdvancedLab'

# storage account
$StorageAccountName = "stor$(Get-Random)"
New-AzResourceGroup -Name $ResourceGroupName -Location $Location
$ctx = New-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName -SkuName Standard_LRS -Location $Location

# service bus
$ServiceBusName = "sb$(Get-Random)"
New-AzServiceBusNamespace -ResourceGroupName $ResourceGroupName -Location $Location -Name $ServiceBusName -SkuName Basic

# Logic app
New-AzLogicApp -ResourceGroupName $ResourceGroupName -Name mylogicapp -Location $Location -Definition '{"definition": {"$schema": "https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#","actions": {},"contentVersion": "1.0.0.0","outputs": {},"parameters": {},"triggers": {}}}'
```
