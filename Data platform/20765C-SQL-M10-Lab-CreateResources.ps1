# CreateAzureResources.ps1


############################################################
# Initialize
############################################################

#Require -Version 5.0
using namespace Microsoft.Azure.Management.Storage.Models;
using namespace System.Management.Automation;

# Clear screen
C:
cd\
cls

# Initialize variables
[string] $subscriptionName = "Azure Pass";
[string] $tenantId = "95964dcc-6b22-49e2-a30e-40987724f954";
[string] $location = "West Europe";

[string] $resGroupName1 = "ResGroup1";
[string] $resGroupName2 = "ResGroup2";

[string] $storageAccName = "20765bst12";
[string] $subnetName = "Subnet1";
[string] $virtualNetworkName = "Vnet1";
[string] $publicIPName = "PublicIP1";
[string] $networkInterfaceName = "NIC1";
[string] $vmName = "VM1";
[string] $computerName = "VM1";

[string] $serverName = "20765bsql12";
[string] $databaseName = "db1";


############################################################
# Sign in to Azure and select subscription
############################################################

Login-AzureRmAccount -SubscriptionName $subscriptionName -TenantId $tenantId;


############################################################
# Check name 
############################################################

#[CheckNameAvailabilityResult]
$avail = Get-AzureRmStorageAccountNameAvailability -Name $storageAccName;
If (-Not $avail.NameAvailable)
{
    throw "Storage account name is not available: $storageAccName";
}



############################################################
# Prompt for credentials 
############################################################

[PSCredential] $vmCred = Get-Credential -Message "Enter the name and password for the VM local administrator" `
                                        -UserName "Student";

[PSCredential] $sqlCred = Get-Credential -Message "Enter the name and password for the SQL Server administrator" `
                                         -UserName "SqlStudent";


############################################################
# Create resource groups
############################################################

New-AzureRmResourceGroup -Name $resGroupName1 -Location $location;
New-AzureRmResourceGroup -Name $resGroupName2 -Location $location;


############################################################
# Create storage account
############################################################

$storageAcc = New-AzureRmStorageAccount -ResourceGroupName $resGroupName1 `
                                        -Name $storageAccName `
                                        -SkuName Standard_LRS `
                                        -Kind Storage `
                                        -Location $location;


############################################################
# Create virtual network
############################################################

$subnet = New-AzureRmVirtualNetworkSubnetConfig -Name $subnetName `
                                                -AddressPrefix 10.0.0.0/24;

$vnet = New-AzureRmVirtualNetwork -Name $virtualNetworkName `
                                  -ResourceGroupName $resGroupName1 `
                                  -Location $location `
                                  -AddressPrefix 10.0.0.0/16 `
                                  -Subnet $subnet;


############################################################
# Create public IP 
############################################################

$publicIP = New-AzureRmPublicIpAddress -Name $publicIPName `
                                       -ResourceGroupName $resGroupName1 `
                                       -Location $location `
                                       -AllocationMethod Dynamic;

$nic = New-AzureRmNetworkInterface -Name $networkInterfaceName `
                                   -ResourceGroupName $resGroupName1 `
                                   -Location $location `
                                   -SubnetId $vnet.Subnets[0].Id `
                                   -PublicIpAddressId $publicIP.Id;


############################################################
# Create virtual machine
############################################################

$vmConfig = New-AzureRmVMConfig -VMName $vmName -VMSize "Basic_A1";

$vmConfig = Set-AzureRmVMOperatingSystem -VM $vmConfig -Windows `
                                         -ComputerName $computerName `
                                         -Credential $vmCred `
                                         -ProvisionVMAgent -EnableAutoUpdate;

$vmConfig = Set-AzureRmVMSourceImage -VM $vmConfig -PublisherName "MicrosoftWindowsServer" `
                                     -Offer "WindowsServer" -Skus "2016-DataCenter" `
                                     -Version "latest";

$vmConfig = Add-AzureRmVMNetworkInterface -VM $vmConfig -Id $nic.Id;

[string] $blobPath = "vhds/" + $vmName + "OsDisk1.vhd";
[string] $osDiskUri = $storageAcc.PrimaryEndpoints.Blob.ToString() + $blobPath;

$vmConfig = Set-AzureRmVMOSDisk -VM $vmConfig -Name "OsDisk1" `
                                -VhdUri $osDiskUri -CreateOption FromImage;

# Create a new VM
# The command may take several minutes to complete
New-AzureRmVM -ResourceGroupName $resGroupName1 -Location $location -VM $vmConfig;


############################################################
# Create and configure SQL Server
############################################################

# The command may take several minutes to complete
New-AzureRmSqlServer -ResourceGroupName $resGroupName2 `
                     -ServerName $serverName `
                     -SqlAdministratorCredentials $sqlCred `
                     -Location $location `
                     -ServerVersion "12.0";


############################################################
# Create SQL database
############################################################

# This may take a short while to complete
New-AzureRmSqlDatabase -ResourceGroupName $resGroupName2 `
                       -ServerName $serverName `
                       -DatabaseName $databaseName `
                       -Edition Basic;




############################################################
# Uninstall
############################################################

# These can take a few minutes to run
Remove-AzureRmResourceGroup -Name $resGroupName1;
Remove-AzureRmResourceGroup -Name $resGroupName2;

