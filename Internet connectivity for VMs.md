Log on to the Hyper-V Host Server using the RDP connection
Close any Virtual Machine Connection windows that are open
Open Server Manager
Click Tools, Routing and Remote Access
Note! Don't click Remote Access Management. Click Routing and Remote Access, which is two items below Remote Access Management.
Note! If the Routing and Remote Access item isn't available, then you're probably logged on to the wrong server. Make sure you're logged on to the Hyper-V Host server using the RDP Connection, and minimize or close any Virtual Machine Connection windows.
Rightclick the servername (WIN-<something>) and choose Configure and Enable Routing and Remote Access.
Click Next and choose NAT (second option in the list). Click Next.
Select the interface referencing the 10.x.x.x (DHCP) IP Address. If this window doesn't display any Network Interfaces, click Cancel and repeat the last two steps to open the wizard again.
Finish the wizard with all the default options.
Start a web browser, vsist google.com and verify internet connectivity.
Open a VM, start a web browser, vsist google.com and verify internet connectivity.
If the previous step failed, perform the following steps to troubleshoot the problem:
- Start PowerShell
- run  Get-DnsClientServerAddress -AddressFamily ipv4
- note the DNS Server address
- ping the DNS Server address
- ping google.com
- run NSLOOKUP google.com
