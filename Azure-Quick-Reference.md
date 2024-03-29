## Azure Storage

### Access Tier
Defines the availability vs storage and access costs.
- Hot: up to 99.99% availability, highest price per KB, lower access costs
- Cool: up to 99.9% availability, lower price per KB, higher access costs
- Archive, unspecified availability, offline storage, lowest price per KB, highest access costs, can take a day for data retrievals, not available through Azure portal

### Replication
- LRS: Locally redundant storage: synchronous replica, three copies in 1 datacenter
- ZRS: Zone-redundant storage: synchronous replica, three copies in 2 datacenters, replicated to secondary facility, block blobs only
- GRS: Geo-redundant storage: async repl to secondary region, predefined pair, 6 copies in total
- RA-GRS: GRS with readable replica

### Storage Account Kind
- v2: all available replication configurations, all available access tiers
- v1: no configurable access tiers, only LRS/GRS/RA-GRs replication
- Blob: no file/table/queue storage, hot + cool access tiers, only LRS/GRS/RA-GRs replication


## Azure VMs
### Azure VM Sizes
Source: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes
- A Basic, classic
- B Burstable, budget, economical
- D General, Faster CPUs and local Hyper-V host SSD (temporary disk), Dv2 series: 35% faster CPU than D-series
- E Memory optimized (relates to cpu to memory ratio)
- F Compute optimized (relates to cpu to memory ratio)
- G Large workload, up to 448 GB of RAM and 64 data disks
- H High-performance computing, high troughput network adapters
- L Storage optimized, low-latency
- M In-memory workloads
- N Deep learning, graphic rendering, video editing


## Azure Networking
### Popular ports
- TCP/22 SSH
- TCP/UDP/53 DNS
- TCP/80 HTTP
- TCP/443 HTTPS
- TCP/UDP/445 SMB, Azure Storage account
- TCP/UDP/389 LDAP
- TCP/UDP/636 LDAP/SSL
- TCP/1433 Azure SQL DB / TDS
- TCP/UDP/3389 RDP
- TCP/5985 WinRM
- TCP/5986 WinRM


## Azure Identity
### Azure Active Directory features and service tiers
- Free
  - 500.000 Object Limit
  - Azure AD Connect sync
- Office 365 apps
  - No Object Limit
  - Company branding
  - Self-service password reset for cloud users
  - SLA
  - Device write-back
- P1
  - Self-service password reset/change/unlock with on-premises write-back
  - Azure AD Join
  - Connect Health
  - Advanced Group Access Management (Dynamic Groups, naming policy, expiration)
  - Conditional Access
    - If-then statements, if a user wants to access a resource, then they must complete an action.
    - Common policies
      - require MFA for admins
      - require MFA for specific app access
      - require managed devices for specific apps
      - block or grant from specific locations
      - block risky sign-in behaviors
    - https://docs.microsoft.com/nl-nl/azure/active-directory/conditional-access/overview
  - MFA with Conditional Access
    - https://docs.microsoft.com/en-us/azure/active-directory/authentication/howto-mfa-getstarted#enable-multi-factor-authentication-with-conditional-access
  - 3rd party MFA partner integration
- P2
  - Vulnerabilities and risky accounts detection
  - Risk events investigation
    - https://docs.microsoft.com/en-us/azure/active-directory/reports-monitoring/concept-risk-events
  - Risk based Conditional Access policies
  - PIM
  - Access Reviews
- Source https://azure.microsoft.com/en-us/pricing/details/active-directory/


## Azure Availability
- https://azure.microsoft.com/en-us/support/legal/sla/summary/
- https://azure.microsoft.com/en-us/support/legal/sla/
- 99%, ca 4 days per year
  - Storage account cool access tier for write requests
- 99.9%, ca 8 hours per year
  - most services
  - Azure Active Directory Basic and Premium
  - Storage Account Hot access tier for read requests
  - Storage Account RA-GRS Replication + Cool access tier for read requests
  - application gateway
- 99.95% ca 4 hours per year
  - API mgmt
  - App svc (not free or shared tiers)
  - Application gateway
  - Azure firewall
  - Azure Databricks
  - VM in availability set with 2+ instances
  - ExpressRoute
  - Azure Functions (ex Consumption Plans)
  - Machine Learning Request Response Service API transactions
  - Virtual WAN
  - VPN Gateway (Standard+, not Basic)
- 99.99%, less than 1 hour per year
  - Azure Front Door
  - DDoS Protection
  - Event Grid
  - Load Balancer
  - Azure SQL DB (Basic tier also), Cosmos DB, MySQL, PostgreSQL
  - SAP HANA on Azure Large Instances
  - Storage Account RA-GRS Replication + Hot access tier for read requests
  - Traffic Manager
- 99.999%
  - Azure Cosmos DB configured with multiple regions as writable endpoints


## Azure resources on the web

### Azure service URI's
- onmicrosoft.com: Active Directory
- cloudapp.net: VM
- azurewebsites.net: website
- blob.core.windows.net: blob storage
- file.core.windows.net: file share
- table.core.windows.net: table storage
- queue.core.windows.net: queue storage
- database.windows.net: SQL
- trafficmanager.net: Traffic Manager
- documents.azure.com: Cosmos DB
- vault.azure.net: Azure Key vault
- servicebus.windows.net: Azure Service Bus
- azurecr.io: Container Registry

### Microsoft
- https://azure.microsoft.com Azure frontpage
- https://azure.microsoft.com/en-us/status/ Azure status
- https://azure.microsoft.com/en-us/pricing/calculator/ Azure Pricing Calculator
- https://azure.microsoft.com/en-us/pricing/tco/calculator/ Azure Total Cost of Ownership (TCO) Calculator
- https://portal.azure.com primary Azure management interface
- https://resources.azure.com Azure Resource Explorer, interact with Azure Resource Management APIs, JSON editor
- https://docs.microsoft.com/en-us/azure/ Microsoft Azure Documentation
- https://docs.microsoft.com/en-us/azure/architecture/best-practices/naming-conventions Naming rules and restrictions for Azure resources and a baseline set of recommendations for naming conventions
- https://github.com/Azure APIs, SDKs and open source projects from Microsoft Azure
- https://github.com/Azure/azure-quickstart-templates Azure Resource Manager QuickStart Templates
- https://github.com/mspnp Microsoft patterns & practices
- https://docs.microsoft.com/en-us/archive/blogs/tangent_thoughts/bookmark-this-aka-msazureshortcuts Azure Shortcuts

### Free ebooks and whitepapers (by year of release)
- https://azure.microsoft.com/en-us/resources/azure-networking-cookbook/ free ebook 2020
- https://gallery.technet.microsoft.com/Inside-the-Operations-2928e342 free ebook 2019
- https://azure.microsoft.com/en-us/resources/azure-for-architects/ free ebook 2019
- https://azure.microsoft.com/en-us/resources/principles-of-data-science/ 2019
- https://azure.microsoft.com/mediahandler/files/resourcefiles/security-best-practices-for-azure-solutions/Azure%20Security%20Best%20Practices.pdf - free whitepaper 2019
- https://azure.microsoft.com/en-us/resources/learn-azure-in-a-month-of-lunches/ free ebook 2018
- https://azure.microsoft.com/en-us/resources/designing-distributed-systems/ Designing Distributed Systems 2018
- https://azure.microsoft.com/en-us/campaigns/developer-guide/ - free ebook 2017
- https://azure.microsoft.com/en-us/resources/truly-consistent-hybrid-cloud-with-microsoft-azure/en-us/ - free whitepaper 2017
- https://blogs.msdn.microsoft.com/microsoft_press/2016/09/01/free-ebook-microsoft-azure-essentials-fundamentals-of-azure-second-edition/ free ebook 2016

### Third party
- https://azurecharts.com/ Overview of Azure services. Linked directly to Azure Service 360° for service summary information
- https://azureprice.net/ Azure VM Comparison
- http://azurestorage.azurewebsites.net Azure Storage web explorer
- https://azurespeedtest.azurewebsites.net/ Azure Speed Test 2.0
- http://www.azurespeed.com/ Azure Latency Test

### Training and Learning
- https://www.pluralsight.com/partners/microsoft/azure Pluralsight and Microsoft have partnered to help become an expert in Azure. With skill assessments and over 130 courses across three Azure roles, you can focus your time on understanding your strengths and skill gaps and learn Azure as quickly as possible.
- https://www.microsoft.com/handsonlabs Get hands-on with cloud technologies from Microsoft. Practice with the latest cloud products and services in a live environment and advance your cloud skills for free.
- https://docs.microsoft.com/en-us/learn/azure/ Unlock your cloud skills in minutes.


