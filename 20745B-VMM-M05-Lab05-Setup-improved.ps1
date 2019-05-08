$SVR_name_host = 'LON-HOST1.Adatum.com'
$SVR_name_DC = 'LON-DC1.Adatum.com'
$SVR_name_VMM = 'LON-VMM.Adatum.com'

$SecurePassword = (ConvertTo-Securestring –asplaintext –force 'Pa55w.rd')
$credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList 'Adatum\Administrator',$SecurePassword

Register-DnsClient

# Recreate London Host Group.
#
New-SCVMHostGroup -VMMServer $SVR_name_VMM -Name "London Host Group"

# Recreate VMMRunas account
#
New-SCRunAsAccount -Credential $credentials -Name "Adatum\VMMRunas" -Description "Adatum\VMMRunas"

#Add LON-HOST1 Hyper-V host to London Host Group
#
$RunAsAccount = Get-SCRunAsAccount -Name "Adatum\VMMRunas"
Add-SCVMHost $SVR_name_host -VMHostGroup "London Host Group" -RunAsynchronously -Credential $RunAsAccount

# Create the London Host 1 and London Host 2 Host Groups.
#
New-SCVMHostGroup -VMMServer $SVR_name_VMM -Name "London Hosts 1"
New-SCVMHostGroup -VMMServer $SVR_name_VMM -Name "London Hosts 2"

#
# Create LON-SYSPREP VM on LON-HOST1 and copy answer file

$Extracted = "\\LON-HOST1\Base\"
$Drive = ((Hyper-V\Get-VM $SVR_name_DC).Path).Substring(0,3)   # "C:\" correction
$VM_Path = $Drive + "VMs\LON-SYSPREP"
$VHD_Path = $Drive + "VMs\LON-SYSPREP\LON-SYSPREP.vhd"
$VHD_Base = $Extracted + "Base17C-WS16-1607.vhd"

# region corrections
mkdir (Join-Path $Drive 'VMs')
New-SmbShare -Path (Join-Path $Drive '\Program Files\Microsoft Learning\Base') -Name Base
# endregion

Hyper-V\New-VM -Name LON-SYSPREP -Path $VM_Path -MemoryStartupBytes 1GB -Generation 1 -BootDevice IDE
Hyper-V\New-VHD –ParentPath $VHD_Base –Path $VHD_Path -Differencing
Hyper-V\Get-VM LON-SYSPREP | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -SwitchName "Internal Network"

Mount-VHD $VHD_Path
$Disk_Number = (Get-Disk).Number.Count - 1
Set-Disk -Number $Disk_Number -IsOffline $false
Set-Partition -DiskNumber $Disk_Number -PartitionNumber 2 -NewDriveLetter X
Copy-Item C:\Labfiles\mod05\Unattend.xml X:\Windows\System32\Sysprep
Dismount-VHD $VHD_Path

Hyper-V\Add-VMHardDiskDrive -VMName LON-SYSPREP -ControllerType IDE -Path $VHD_Path
Hyper-V\Start-VM LON-SYSPREP -Passthru
