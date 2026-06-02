<#
This script prepares the environment for 20741B Module 5 IPAM.
It also contains all commands for Module 5 Lab, Exercise 1.
Run this command from the HOST server.
#>

Get-VM | Stop-VM -TurnOff
Get-VM | Get-VMSnapshot | Restore-VMSnapshot
Get-VM | Set-VMProcessor -Count 2   # setup/prov duurt lang met 1 core!
Start-VM -Name *LON-DC1
Sleep 60   # wait for domain
Start-VM -Name *SV*, *EU*
vmconnect localhost 20741b-lon-svr2

<#
This bug prevents us from running scripts using Invoke-Command
An error has occurred which Windows PowerShell cannot handle. A remote session might have ended.
#>

# Log on to 20741B-LON-SVR1 and run this script:
    #Taken from LON-SVR1_Mod05_Setup.ps1
    #Install and configure DHCP as in Mod 1
    Add-WindowsFeature DHCP, RSAT-DHCP
    Add-DhcpServerInDC

    #Install and configure DNS as in Mod 2
    Add-WindowsFeature DNS, RSAT-DNS-Server
    Add-DnsServerPrimaryZone -Name "contoso.com" -ZoneFile "contoso.com"
    Add-DnsServerResourceRecordA -Name "www" -ZoneName "contoso.com" -IPv4Address 172.16.0.11
    Add-DnsServerResourceRecordA -Name "mail" -ZoneName "contoso.com" -IPv4Address 172.16.0.12


# Log on to 20741B-TOR-SVR1 and run this script:
    #Taken from TOR-SVR1_Mod05_Setup.ps1
    #Install and configure DHCP as in Mod 1
    Add-WindowsFeature DHCP, RSAT-DHCP
    Add-DhcpServerInDC
    Add-DhcpServerv4Scope -Name "Houston Wired" -StartRange 172.16.20.2 -EndRange 172.16.21.254 -SubnetMask 255.255.254.0 -Description "Houston Wired"
    netsh dhcp server scope 172.16.20.0 set optionvalue 003 ipaddress 172.16.20.1
    netsh dhcp server scope 172.16.20.0 set optionvalue 006 ipaddress 172.16.0.10
    Add-DhcpServerv4Scope -Name "Mexico City Wired" -StartRange 172.16.22.2 -EndRange 172.16.22.254 -SubnetMask 255.255.255.0 -Description "Mexico City Wired"
    netsh dhcp server scope 172.16.22.0 set optionvalue 003 ipaddress 172.16.22.1
    netsh dhcp server scope 172.16.22.0 set optionvalue 006 ipaddress 172.16.0.10
    Add-DhcpServerv4Scope -Name "Portland Wired" -StartRange 172.16.23.2 -EndRange 172.16.23.254 -SubnetMask 255.255.255.0 -Description "Portland Wired"
    netsh dhcp server scope 172.16.23.0 set optionvalue 003 ipaddress 172.16.23.1
    netsh dhcp server scope 172.16.23.0 set optionvalue 006 ipaddress 172.16.0.10
    Add-DhcpServerv4Failover -Name TOR-LON-Failover -PartnerServer Lon-SVR1.Adatum.com -ScopeID 172.16.20.0,172.16.22.0,172.16.23.0 -MaxClientLeadTime 0:15:00 -ServerRole Standby


# Log on to 20741B-SYD-SVR1 and run this script:
    #Taken from SYD-SVR1_Mod05_Setup.ps1
    #Install and configure DNS as in Mod 2
    Add-WindowsFeature DNS, RSAT-DNS-Server
    #Add Forwarder
    C:\Windows\System32\Dnscmd.exe /resetforwarders 131.107.0.100
    #Add Conditional Forwarder
    Add-DnsServerConditionalForwarderZone -Name "Contoso.com" -MasterServers 172.16.0.1
    #Promote to DC
    Install-WindowsFeature AD-Domain-Services
    Import-Module ADDSDeployment
    $passwordstring = ConvertTo-SecureString 'Pa$$w0rd' -AsPlainText -Force
    Install-ADDSDomainController -DomainName Adatum.com -SafeModeAdministratorPassword $passwordstring -Force
