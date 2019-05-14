## Azure Availability
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


## Azure URLs (services only, no references to docs)
- Azure.microsoft.com: frontpage
- portal.azure.com: primary management interface
- manage.windowsazure.com: classic Azure management interface
- cloudapp.net: VM
- azurwebsites.net: website
- azurestorage.azurewebsites.net
  - blob.core.windows.net: blob storage
  - file.core.windows.net: file share
  - table.core.windows.net: table storage
  - queue.core.windows.net: queue storage
  - database.windows.net: SQL
- onmicrosoft.com: Active Directory
- trafficmanager.net: Traffic Manager
- resources.azure.com: Azure Resource Explorer, interact with Azure Resource Management APIs, JSON editor


## Azure VM Sizes
Source: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes
- A Basic, classic
- B Burstable, economical
- D General, Faster CPUs and local Hyper-V host SSD (temporary disk), Dv2 series: 35% faster CPU than D-series
- E Memory optimized
- F Compute optimized
- G Large workload, up to 448 GB of RAM and 64 data disks
- H High-performance computing
- L Storage optimized, low-latency
- M In-memory workloads
- N Deep learning, graphic rendering, video editing


## Azure Storage
### Replication
- LRS: Locally redundant storage: synchronous replica, three copies in 1 datacenter
- ZRS: Zone-redundant storage: synchronous replica, three copies in 2 datacenters, replicated to secondary facility, block blobs only
- GRS: Geo-redundant storage: async repl to secondary region, predefined pair, 6 copies in total
- RA-GRS: Read-Acces: GRS with secondary read

