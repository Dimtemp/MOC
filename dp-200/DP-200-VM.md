# This procedure creates a SQL VM that can be used for the DP-200 training.
You can use this VM to install software like Visual Studio code. Or run the software that has been provided by Microsoft for the Streaming analytics lab.

## Create the VM
1. Open the Azure Portal
1. Click Create a resource
1. Select Compute and click SQL Server 2017 Enterprise Windows Server 2016
1. Click Create new for the resource group: and enter SQLVMRG as the name.
1. Enter SQLVM as the Virtual machine name.
1. Select a region closest to you.
1. Enter a unique username and password. Please assume that many people will try to get into your VM.
1. Keep the default port (3389) selected.
1. Click the disks tab.
1. Select Standard SSD.
1. Select the SQL Server settings tab.
1. At the Storage section, click Change configuration.
1. At the Storage optimization, select General.
1. Change 1024 GiB to 16 GiB and click Ok.
1. Click Review + create.
1. Notice the price of the VM and notice the warning that refers to the RDP port.
1. Click Create.

## Connect to the VM
1. Wait for the VM to be deployed.
1. Select Virtual machines from the left panel in the Azure portal.
1. Select the SQL VM.
1. Copy the public IP address to your clipboard.
1. Try to connect with RDP. From Windows, click Start, type mstsc, click Remote Desktop Connection.
1. Enter the IP address and click Connect.
1. Enter the credentials you specified in the previous procedure.

## Optional: create a bastion host when RDP connectivity is not provided.
When you cannot connect with RDP because RDP traffic is blocked you can use a bastion host to connect.
1. Open the Azure Portal
1. Click Create a resource
1. Search for Bastion and select it.
1. Verify it's by Microsoft and click Create.
1. Create a new resource gorup.
1. Select the same region as your SQL VM.
1. Select an existing VNET that contains the SQL VM.
1. If there's a message about an assocation, click Manage subnet configuration. Ask the instructor for IP address details.
1. Select the AzureBastionSubnet.
1. Leave all other options at their default values.
1. Click Review + create and Create.


