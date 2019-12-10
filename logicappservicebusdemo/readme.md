This Azure template creates a storage account, two logic apps and a service bus, for the purpose of demonstrating a logic app and service bus.

Actions
1) Create a blob container in the storage account
2) Edit logicapp1, and monitor the storage account blob container. Write a message into the service bus when a file is detected.
3) Edit logicapp2, and monitor the service bus. Write a message into the storage account queue when a message is detected.

DISCLAIMER: use on your own risk!

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FDimtemp%2FMOC%2Fmaster%2Flogicappservicebusdemo%2Ftemplate.json" target="_blank">
<img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.png"/>
</a>
