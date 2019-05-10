## Availability
- 99.9%, ca 8 hour per year: application gateway
- 99.99%, ca 1 hour per year


## Azure URLs
- Azure.microsoft.com: algemene webpage, vooral presales
- portal.azure.com: nieuwe portal
- manage.windowsazure.com: bedieningspaneel oud
- cloudapp.net   VM
- azurwebsites.net   website
- azurestorage.azurewebsites.net
- windows.net
  - core.windows.net         storage
  - blob.core.windows.net    storage
  - file.core.windows.net    file share
  - database.windows.net   SQL
- onmicrosoft.com   AD
- trafficmanager.net
- resources.azure.com
  soort van online ARM JSON editor?


## VM Sizes
- A basic
- B burstable, economical
- F compute
- D general, Faster CPUs and local Hyper-V host SSD (temporary disk), Dv2 series: 35% faster CPU than D-series
- E memory optimized
- G compute, large workload, up to 448 GB of RAM and 64 data disks
- M compute - in-memory workloads
- L storage optimized, low-latency
- H high-performance computing
- NC/NV compute and graphics
- ND AI, PX40 GPU


## Storage
- LRS: Locally redundant storage: synchronous replica, three copies in 1 datacenter
- ZRS: Zone-redundant storage: synchronous replica, three copies in 2 datacenters, replicated to secondary facility, block blobs only
- GRS: Geo-redundant storage: async repl to secondary region, predefined pair, 6 copies in total
- RA-GRS: Read-Acces: GRS with secondary read

egress targets for the secondary location are identical to those for the primary location.


