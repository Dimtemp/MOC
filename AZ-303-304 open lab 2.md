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
$Definition = '{"$schema":"https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#","contentVersion"
:"1.0.0.0","parameters":{},"triggers":{},"actions":{},"outputs":{}}'
New-AzLogicApp -ResourceGroupName $ResourceGroupName -Name mylogicapp -Location $Location -Definition $Definition
```

## Configure Storage account
1. Open the storage account and create a Blob container.

## Configure Service Bus
1. Open the Service Bus and create a queue.

## Create a workflow in the logic app
1. Open the logic app, and select the Blank Logic App template.
1. Add Azure Storage blob.
1. Specify "When a blob is added or modified"
1. Create a name, and specify the sotrage account you just created.
1. Specify the correct container.
1. Optionally scroll down.
1. Click New Step.
1. Select Azure Service Bus
1. Select Send Message.
1. Enter a name for the connection.

## Test the logic app
1. Run the Logic app
1. Return to the storage account and create a new file in the container.
1. Inspect the Logic app. No errors?
1. Inspect the service bus. Notice the output in the graphs. 

