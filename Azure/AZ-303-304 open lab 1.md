# Azure Architect open lab 1

## Scenario
You will create a high available website for your organization. It consists of two virtual machines, divided over two regions.

## Procedure
1. Create a Windows Server VM in West Europe.
1. Create another Windows Server VM in any other region.
1. From the Azure Portal, open port 80 on both VMs.
1. Log on using RDP on both VMs.
1. Install IIS using this PowerShell command: ```Install-WindowsFeature Web-Server```
1. Using Windows Explorer, navigate to C:\Inetpub\wwwroot and create a document with this name: ```default.htm```
1. Enter this line in the document on the first VM: <html><body>Greetings from one VM</body></html>
1. Enter this line in the document on the second VM: <html><body>Greetings from the other VM</body></html>
1. Create a Traffic Manager profile and specify the public IP address of both VMs as an endpoint.
1. Open a new tab in your web browser and visit your website using the URL you specified when creating the traffic manager.
