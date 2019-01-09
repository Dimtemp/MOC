# This script executes some of the cumbersome activities during lab 6 of the 20745 training

# part 1: Lab06-Setup.ps1 from Allfiles

$SVR_name1 = 'LON-SVR1.Adatum.com'
$SVR_name2 = 'LON-SVR2.Adatum.com'
$SVR_name3 = 'LON-SVR3.Adatum.com'

$SVR_name_host = 'LON-HOST1.Adatum.com'
$SVR_name_VMM = 'VMM-HA2.Adatum.com'

$SecurePassword = (ConvertTo-Securestring –asplaintext –force 'Pa55w.rd')
$credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList 'Adatum\Administrator',$SecurePassword

Register-DnsClient

# Recreate London Host Group.
New-SCVMHostGroup -VMMServer $SVR_name_VMM -Name "London Host Group"

# Recreate VMMRunas account
New-SCRunAsAccount -Credential $credentials -Name "Adatum\VMMRunas" -Description "Adatum\VMMRunas"

#Add LON-HOST1 Hyper-V host to London Host Group
$RunAsAccount = Get-SCRunAsAccount -Name "Adatum\VMMRunas"
Add-SCVMHost $SVR_name_host -VMHostGroup "London Host Group" -RunAsynchronously -Credential $RunAsAccount

# Create the London Host 1 and London Host 2 Host Groups.
New-SCVMHostGroup -VMMServer $SVR_name_VMM -Name "London Hosts 1"
New-SCVMHostGroup -VMMServer $SVR_name_VMM -Name "London Hosts 2"

# Add LON-SVR1 to the London Hosts 1 host group and LON-SVR2 to the London Hosts 2 host group.
Add-SCVMHost $SVR_name1 -VMHostGroup "London Hosts 1" -RunAsynchronously -Credential $RunAsAccount
Add-SCVMHost $SVR_name2 -VMHostGroup "London Hosts 2" -RunAsynchronously -Credential $RunAsAccount

Invoke-Command -ComputerName LON-SVR3 { 
    New-SMBShare –Name “VMMLibrary” –Path 'D:\VMMLibrary' -ChangeAccess 'Adatum\Domain Users'
}

Add-SCLibraryShare -JobGroup "faeddae9-7d3f-40f9-8fbf-6ff433ccaf2e" -SharePath "\\$SVR_name_host\Base"
Add-SCLibraryServer -ComputerName $SVR_name_host -JobGroup "faeddae9-7d3f-40f9-8fbf-6ff433ccaf2e" -RunAsynchronously -Credential $RunAsAccount
Add-SCLibraryShare -JobGroup "fbcf38ae-1b74-4b4b-82ba-7d3a488abe7e" -SharePath "\\$SVR_name3\VMMLibrary"
Add-SCLibraryServer -ComputerName $SVR_name3 -JobGroup "fbcf38ae-1b74-4b4b-82ba-7d3a488abe7e" -RunAsynchronously -Credential $RunAsAccount


# part 2: time-saving commands that would be performed manually during the lab

$UserName = 'Adatum\Administrator'
$LocalUserName = '.\Administrator'
$Credential1 = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $UserName, $SecurePassword
$Credential2 = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $LocalUserName, $SecurePassword
New-ADGroup -Name 'VMM-NC-Mgmt' -GroupScope DomainLocal -Path 'OU=IT,DC=Adatum,DC=com'
Add-ADGroupMember -Identity 'VMM-NC-Mgmt' -Members 'Domain Admins'
New-ADGroup -Name 'VMM-NC-Clients' -GroupScope DomainLocal -Path 'OU=IT,DC=Adatum,DC=com'
New-ADUser -AccountPassword (ConvertTo-SecureString 'Pa55w.ord' -AsPlainText -Force) -ChangePasswordAtLogon $false -Enabled $true -Name 's-VMM-NC-Client' -Path 'OU=IT,DC=Adatum,DC=com'
Add-ADGroupMember -Identity 'VMM-NC-Clients' -Members 's-VMM-NC-Client'
New-SCRunAsAccount -Name 'ADATUM\s-VMM-NC-Client' -Credential $Credential1
New-SCRunAsAccount -Name $LocalUserName -Credential $Credential2 -NoValidation
New-SelfSignedCertificate -KeyUsageProperty All -Provider 'Microsoft Strong Cryptographic Provider' -FriendlyName 'AdatumNC' -DnsName @('NC-VM01.adatum.com')
mkdir \\LON-SVR3\VMMLibrary\NC\NCCertificate.cr
mkdir \\LON-SVR3\VMMLibrary\NC\TrustedRootCertificate.cr
