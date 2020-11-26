function Get-ServiceProcess {
<#
.SYNOPSIS
This script shows active services and its running process
#>
    [CmdletBinding()]
    param(
        [string[]]$ComputerName = $env:COMPUTERNAME
    )

    process{
        foreach($currentComputerName in $computername){
            $serviceList = Get-WmiObject win32_service -ComputerName $currentComputerName | Where-Object state -eq 'running'
            foreach($service in $serviceList) {
                $filter = "processid=$($service.processid)"
                Write-Verbose "het filter is nu $filter"
                $process = Get-WmiObject win32_process -ComputerName $currentComputerName -Filter $filter
                $props = @{
                    'processid'=$service.processid;
                    'computername'=$currentComputerName;
                    'servicename'=$service.name;
                    'processname'=$process.name
                }
                New-Object psobject -Property $props
            }
        }
    }
}

Get-ServiceProcess 



# BUG 1: }
# BUG 2: $svcs
# BUG 3: filter = processid ipv ip
# BUG 4: where state -eq 'running'
