<#
This script executes some of the cumbersome activities during lab 6 of the 20745 training
required: PowerShell Modules for VMM and Active Directory
Execute this script with domain admin and VMM admin credentials
Remember to verify memory on LON-SVR1: 8GB Ram or more is optimal
#>

# Install-WindowsFeature RSAT-AD-PowerShell, RSAT-Clustering-PowerShell, RSAT-Hyper-V-Tools
Install-WindowsFeature RSAT-ADDS-Tools, RSAT-AD-PowerShell

# part 1: Lab06-Setup.ps1 from Allfiles

$SVR_name1 = 'LON-SVR1.Adatum.com'
$SVR_name2 = 'LON-SVR2.Adatum.com'
$SVR_name3 = 'LON-SVR3.Adatum.com'

$SVR_name_host = 'LON-HOST1.Adatum.com'
$SVR_name_VMM = 'VMM-HA2.Adatum.com'

$LocalUserName  = '.\Administrator'
$DomainUserName = 'ADATUM\Administrator'
$NCUserName     = 's-VMM-NC-Client'
$SecurePassword = (ConvertTo-Securestring –asplaintext –force 'Pa55w.rd')

$LocalCred  = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $LocalUserName, $SecurePassword
$DomainCred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $DomainUserName, $SecurePassword
$NCCred     = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "ADATUM\$NCUserName", $SecurePassword

Register-DnsClient

# create VMMLibrary share on LON-SVR3
Invoke-Command -ComputerName LON-SVR3 { 
    New-SMBShare –Name 'VMMLibrary' –Path 'D:\VMMLibrary' -ChangeAccess 'Adatum\Domain Users'
}

# create VMMRunas account
New-SCRunAsAccount -Credential $DomainCred -Name 'Adatum\VMMRunas' -Description 'Adatum\VMMRunas'
$RunAsAccount = Get-SCRunAsAccount -Name 'Adatum\VMMRunas' | Select-Object -First 1

# create library objects
Add-SCLibraryShare -JobGroup 'faeddae9-7d3f-40f9-8fbf-6ff433ccaf2e' -SharePath "\\$SVR_name_host\Base"
Add-SCLibraryServer -ComputerName $SVR_name_host -JobGroup 'faeddae9-7d3f-40f9-8fbf-6ff433ccaf2e' -RunAsynchronously -Credential $RunAsAccount
Add-SCLibraryShare -JobGroup 'fbcf38ae-1b74-4b4b-82ba-7d3a488abe7e' -SharePath "\\$SVR_name3\VMMLibrary"
Add-SCLibraryServer -ComputerName $SVR_name3 -JobGroup 'fbcf38ae-1b74-4b4b-82ba-7d3a488abe7e' -RunAsynchronously -Credential $RunAsAccount


# create Host Groups
New-SCVMHostGroup -VMMServer $SVR_name_VMM -Name 'London Host Group'
New-SCVMHostGroup -VMMServer $SVR_name_VMM -Name 'London Hosts 1'
New-SCVMHostGroup -VMMServer $SVR_name_VMM -Name 'London Hosts 2'

#Add LON-HOST1 Hyper-V host to London Host Group
Add-SCVMHost $SVR_name_host -VMHostGroup 'London Host Group' -RunAsynchronously -Credential $RunAsAccount

# Add LON-SVR1 to the London Hosts 1 host group and LON-SVR2 to the London Hosts 2 host group.
Add-SCVMHost $SVR_name1 -VMHostGroup 'London Hosts 1' -RunAsynchronously -Credential $RunAsAccount
Add-SCVMHost $SVR_name2 -VMHostGroup 'London Hosts 2' -RunAsynchronously -Credential $RunAsAccount



# part 2: time-saving commands that would be performed manually during the lab

# Active Directory

Get-ADComputer -Filter * | Where-Object name -match 'nc-vm*' | Remove-ADObject -Recursive

New-ADGroup -Name 'VMM-NC-Mgmt' -GroupScope DomainLocal -Path 'OU=IT,DC=Adatum,DC=com'
Add-ADGroupMember -Identity 'VMM-NC-Mgmt' -Members 'Domain Admins'
Add-ADGroupMember -Identity 'VMM-NC-Mgmt' -Members 'Administrator'

New-ADGroup -Name 'VMM-NC-Clients' -GroupScope DomainLocal -Path 'OU=IT,DC=Adatum,DC=com'
New-ADUser -Name $NCUserName -AccountPassword $SecurePassword -ChangePasswordAtLogon $false -Enabled $true -PasswordNeverExpires $true -Path 'OU=IT,DC=Adatum,DC=com'
Add-ADGroupMember -Identity 'VMM-NC-Clients' -Members $NCUserName


# VMM Run As accounts
New-SCRunAsAccount -Name 'Run As Local Admin' -Credential $LocalCred -NoValidation
New-SCRunAsAccount -Name 'Run As NC Client' -Credential $NCCred


# VMM Library folders
mkdir \\LON-SVR3\VMMLibrary\NC\NCCertificate.cr
mkdir \\LON-SVR3\VMMLibrary\NC\TrustedRootCertificate.cr


# certificate
$CertListing = Get-ChildItem Cert:\LocalMachine\My | Where-Object Subject -match 'NC-VM01'
if ($CertListing.count -gt 0) { $CertListing | ForEach-Object { Remove-Item $_.PSPath -Confirm } }
New-SelfSignedCertificate -KeyUsageProperty All -Provider 'Microsoft Strong Cryptographic Provider' -FriendlyName 'AdatumNC' -DnsName @('NC-VM01.adatum.com')

$Cert = Get-ChildItem Cert:\LocalMachine\My | Where-Object Subject -match 'NC-VM01'
$Cert | Export-Certificate    -FilePath '\\LON-SVR3\VMMLibrary\NC\NCCertificate.cr\NC-VM01.der'
$Cert | Export-PfxCertificate -FilePath '\\LON-SVR3\VMMLibrary\NC\ServerCertificate.cr\NC-VM01.pfx' -Password $SecurePassword 



# Associate SVR1+2 NIC with Management network + IP Pool
'LON-SVR1', 'LON-SVR2' | ForEach-Object {

    $vmHost = Get-SCVMHost | Where ComputerName -EQ $_  # Get-SCVMHost -ID "26176f3a-33c2-41ac-abbe-704672acd614"

    # Get Host Network Adapter 'Microsoft Hyper-V Network Adapter'
    $vmHostNetworkAdapter = Get-SCVMHostNetworkAdapter -VMHost $_ | Where-Object ConnectionName -eq 'Ethernet'
    Set-SCVMHostNetworkAdapter -VMHostNetworkAdapter $vmHostNetworkAdapter -Description "" -AvailableForPlacement $true -UsedForManagement $true

    # Get Logical Network 'Management'
    $logicalNetwork = Get-SCLogicalNetwork | where name -eq Management
    Set-SCVMHostNetworkAdapter -VMHostNetworkAdapter $vmHostNetworkAdapter -AddOrSetLogicalNetwork $logicalNetwork

    Set-SCVMHost -VMHost $vmHost -RunAsynchronously -NumaSpanningEnabled $true
}

# refresh library
Get-SCLibraryShare | Read-SCLibraryShare


# continue the lab exercise with Lab 6A, Exercise 2, Task 3: Import the Network Controller template


# if no VMs exist on LON-SVR2, run this command on LON-SVR2:
<#
Install-WindowsFeature RSAT-Hyper-V-Tools
New-VMSwitch -Name 'Internal Network' -SwitchType Internal
Get-ChildItem -Path D:\ -Recurse -Filter '*.vmcx' | foreach { Import-VM -Path $_.FullName }
#>

# ServerUrl=https://nc-vm01.adatum.com/;ServiceName=Network_Controller_Deployment_v1.0
