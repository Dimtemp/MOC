function New-VMsToDemoMulticasting {
<#
.SYNOPSIS
This function creates several VMs to demo SCCM OSD Multicasting.

.DESCRIPTION
It first asks which VM's to save to free up memory for the new VM's.


.NOTES
27-10-2016
Initial version

28-10-2016
Exports new VMs to CSV

11-03-2019
Adapted to 20703-1A
-MemoryStartupBytes 1GB
-Generation 2 # = x64 boot image only??? Disk part moet dan wel anders. Zie ook blog Henk Hogendoorn
-BootDevice CD | LegacyNetworkAdapter | NetworkAdapter

15-03-2019
CSV Export removed
StartVM param replaced by DoNotStartVM
removed VhdPath param
added WriteProgress

Cleanup:
Get-VM | Where-Object name -match img | Out-GridView -OutputMode Multiple | Stop-VM -Force -Passthru | Remove-VM
#>


    param(
      [int]$NumberOfVmsToCreate = 8,
      [switch]$DoNotStartVM,
      [string]$NewVMBaseName = '20703-1A-LON-IMG',
      [string]$CfgServerName = '20703-1A-LON-CFG-B'
    )

    Get-VM | Where-Object state -eq 'running' | Out-GridView -OutputMode Multiple -Title 'Please select VMs to save so more memory is available. Press cancel to save no VMs' | Save-VM

    $CfgVM = Get-VM | Where-Object name -match $CfgServerName | Get-VMNetworkAdapter
    $CfgSwitch = Get-VMSwitch -Name $CfgVM.SwitchName

    $activity = 'Creating VMs'
    Write-Progress -Activity $activity -CurrentOperation 'creating vms'
    1..$NumberOfVmsToCreate | foreach {
        $VMName = $NewVMBaseName + $_
        Write-Progress -Activity $activity -CurrentOperation $VMName

        $result = New-VM -Name $VMName -NewVHDSizeBytes 120GB -NewVHDPath "$VMName$_.vhdx"
        Add-VMNetworkAdapter -VMName $VMName -IsLegacy $true -SwitchName $CfgSwitch.Name

        # optionally start VMs
        if (!$DoNotStartVM) { Start-VM -VMName $VMName }
    }
    Write-Progress -Activity $activity -Completed

    # Show VM properties
    if (!$DoNotStartVM) {
      Get-VM |
        Where Name -match $NewVMBaseName |
        Get-VMNetworkAdapter -IsLegacy $true |
        Select-Object VMName, MacAddress
    }
}

New-VMsToDemoMulticasting -NewVMBaseName test
