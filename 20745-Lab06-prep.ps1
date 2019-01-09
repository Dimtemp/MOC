# This script executes some of the cumbersome activities during lab 6 of the 20745 training
$UserName = 'Adatum\Administrator'
$LocalUserName = '.\Administrator'
$SecurePassword = (ConvertTo-Securestring –AsPlaintext –Force 'Pa55w.rd')
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
