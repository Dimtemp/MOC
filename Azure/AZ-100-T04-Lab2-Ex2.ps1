<#
AZ-100
Module 4 - Configure and Manage Virtual Networks
Lab 2: Configure Azure DNS
Exercise 2: Configure Azure DNS for private domains
#>

# create a resource group
$rg1 = Get-AzResourceGroup -Name 'az1000401b-RG'
$rg2 = New-AzResourceGroup -Name 'az1000402b-RG' -Location $rg1.Location

# create two Azure virtual networks
$subnet1 = New-AzVirtualNetworkSubnetConfig -Name subnet1 -AddressPrefix '10.104.0.0/24'
$vnet1 = New-AzVirtualNetwork -ResourceGroupName $rg2.ResourceGroupName -Location $rg2.Location -Name az1000402b-vnet1 -AddressPrefix 10.104.0.0/16 -Subnet $subnet1
$subnet2 = New-AzVirtualNetworkSubnetConfig -Name subnet1 -AddressPrefix '10.204.0.0/24'
$vnet2 = New-AzVirtualNetwork -ResourceGroupName $rg2.ResourceGroupName -Location $rg2.Location -Name az1000402b-vnet2 -AddressPrefix 10.204.0.0/16 -Subnet $subnet2

# create a private DNS zone with the first virtual network supporting registration and the second virtual network supporting resolution
New-AzDnsZone -Name adatum.local -ResourceGroupName $rg2.ResourceGroupName -ZoneType Private -RegistrationVirtualNetworkId @($vnet1.Id) -ResolutionVirtualNetworkId @($vnet2.Id)

# verify that the private DNS zone was successfully created
Get-AzDnsZone -ResourceGroupName $rg2.ResourceGroupName

# In the Cloud Shell pane, upload az-100-04b_01_azuredeploy.json, az-100-04b_02_azuredeploy.json, and az-100-04b_azuredeploy.parameters.json files

# deploy an Azure VM into the first virtual network
New-AzResourceGroupDeployment -ResourceGroupName $rg2.ResourceGroupName -TemplateFile "$home/az-100-04b_01_azuredeploy.json" -TemplateParameterFile "$home/az-100-04b_azuredeploy.parameters.json" -AsJob

# deploy an Azure VM into the second virtual network
New-AzResourceGroupDeployment -ResourceGroupName $rg2.ResourceGroupName -TemplateFile "$home/az-100-04b_02_azuredeploy.json" -TemplateParameterFile "$home/az-100-04b_azuredeploy.parameters.json" -AsJob
