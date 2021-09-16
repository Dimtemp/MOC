# display the hostname
Hostname

Configuration MyDscConfiguration
{
    Node $AllNodes.Where{$_.Role -eq "WebServer"}.NodeName
    {
        WindowsFeature IISInstall
        {
            Ensure = 'Present'
            Name   = 'Web-Server'
        }
    }
    
    Node $AllNodes.Where{$_.Role -eq "VMHost"}.NodeName
    {
        WindowsFeature HyperVInstall {
            Ensure = 'Present'
            Name   = 'Hyper-V'
        }
    }
}

$MyData =
@{
    AllNodes =
    @(
        @{
            NodeName    = 'VM-1'   # REPLACE WITH HOSTNAME
            Role = 'WebServer'
        },

        @{
            NodeName    = 'VM-2'
            Role = 'VMHost'
        }
    )
}

MyDscConfiguration -ConfigurationData $MyData -Output C:\DataTest
Run-DscConfiguration C:\DataTest


# more info
# https://docs.microsoft.com/en-us/powershell/scripting/dsc/configurations/separatingenvdata?view=powershell-7.1
