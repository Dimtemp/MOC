# run this on LON-SVR2

Install-WindowsFeature RSAT-ADDS

New-ADGroup -Name 'Network Controller Admins' -GroupScope Global -PassThru | Add-ADGroupMember -Members 'Administrator', 'beth'
New-ADGroup -Name 'Network Controller Ops' -GroupScope Global -PassThru | Add-ADGroupMember -Members 'Administrator', 'beth'

Install-WindowsFeature NetworkController -IncludeManagementTools

Restart-Computer

$node = New-NetworkControllerNodeObject `
-Name 'Node1' `
-Server 'LON-SVR2.Adatum.com' `
-FaultDomain 'fd:/rack1/host1'  `
-RestInterface 'London_Network'

$Certificate = Get-Item Cert:\LocalMachine\My | Get-ChildItem |
where {$_.Subject -imatch "LON-SVR2" }

Install-NetworkControllerCluster -Node $node `
-ClusterAuthentication Kerberos  `
-ManagementSecurityGroup 'Adatum\Network Controller Admins' `
-CredentialEncryptionCertificate $Certificate

# Error? Run: Clear-NetworkControllerNodeContent

Install-NetworkController -Node $node `
-ClientAuthentication Kerberos `
-ClientSecurityGroup 'Adatum\Network Controller Ops' `
-RestIpAddress '172.16.0.99/24' `
-ServerCertificate $Certificate

$cred = New-Object Microsoft.Windows.Networkcontroller.credentialproperties
$cred.type = "usernamepassword"
$cred.username = "admin"
$cred.value = "abcd"

New-NetworkControllerCredential `
-ConnectionUri https://LON-SVR2.Adatum.com `
-Properties $cred `
–ResourceId cred1

Get-NetworkControllerCredential `
-ConnectionUri https://LON-SVR2.Adatum.com `
-ResourceId cred1
