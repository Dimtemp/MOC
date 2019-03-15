<#
.SYNOPSIS
This script creates several VMs to demo SCCM OSD. It first asks which VM's to save to free up memory for the new VM's.
.NOTES
27-10-2016 Initial version
28-10-2016 Exports new VMs to CSV
11-03-2019 Adapted to 20703-1A

-MemoryStartupBytes 1GB
-Generation 2 # = x64 boot image only??? Disk part moet dan wel anders. Zie ook blog Henk Hogendoorn
-BootDevice CD | LegacyNetworkAdapter | NetworkAdapter
#>

param(
  [int]$NumberOfVmsToCreate = 8,
  [bool]$StartVM = $true,
  [string]$CsvOutputPath = 'c:\NewVMs.csv',
  [string]$NewVmName = '20703-1A-LON-IMG',
  [string]$VhdPath = 'C:\Program Files\Microsoft Learning\20703-1\Drives\20703-1A-LON-IMG',
  [string]$CfgServerName = '20703-1A-LON-CFG-B'
  )

Get-VM | Where-Object state -eq 'running' | Out-GridView -OutputMode Multiple -Title 'Please select VMs to save, or press cancel' | Save-VM

$CfgVM = Get-VM | where name -match $CfgServerName | Get-VMNetworkAdapter
$CfgSwitch = Get-VMSwitch -Name $CfgVM.SwitchName

1..$NumberOfVmsToCreate | foreach {
  New-VM -Name ($NewVmName + $_) -NewVHDSizeBytes 120GB -NewVHDPath ($VhdPath + $_ + '.vhdx')
  Add-VMNetworkAdapter -VMName ($NewVmName + $_) -IsLegacy $true -SwitchName $CfgSwitch.Name

  # optionally start VMs
  if ($StartVM) { Start-VM -VMName ($NewVmName + $_) }
}

# Store VM properties for CSV export later
if ($StartVM) {
  Write-Host "Exporting VMs to $CsvOutputPath..."
  Get-VM | Where Name -match $NewVmName | Get-VMNetworkAdapter -IsLegacy $true |
  Select-Object VMName, MacAddress | Export-CSV $CsvOutputPath -NoTypeInformation
}
else {
  Write-Host 'VMs not started yet, so no export to CSV...'
}

