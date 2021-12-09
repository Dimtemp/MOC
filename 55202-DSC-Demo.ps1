configuration MyFirstConfig {
    node 'localhost' {
        WindowsFeature MyFeature {
            Ensure = 'Present'
            Name = 'Web-Server'
        }
    }
}

<#
Save as ConfigData.psd1
@{
	AllNodes = @(
		@{
			NodeName = '*'
			LogPath = 'C:\MyLogs'
		},
		@{
			NodeName = 'DC1'
			Role = 'DC'
		},
		@{
			NodeName = 'web1'
			Role = 'WebServer'
		}
	)
}
#>

configuration MyFinalConfig {
    param(
        [string]$ComputerName = $env:COMPUTERNAME,
        [string]$FeatureName = 'telnet-client'
    )

    Import-DscResource –ModuleName 'PSDesiredStateConfiguration'

    <#node $ComputerName {
        WindowsFeature MijnFeature {
            Ensure = 'Present'
            #Name = 'Telnet-Client'
            Name = $FeatureName
        }
    }#>

    node $ComputerName {
        MyFirstConfig MyNestedTest {
            
        }
    }

    node $AllNodes.Where({$_.Role -eq 'WebServer'}).NodeName {
        Log SampleMsg {
            Message = 'Sample'
        }
        WindowsFeature MijnFeature {
            Ensure = 'Present'
            Name = 'Web-Server'
        }
    }
}


configuration MyTelnetInstall {
    param($Ensure)
    node localhost {
        WindowsFeature MyFeature {
            Ensure = $Ensure
            Name   = 'Telnet-Client'
        }
    }
}


configuration MyTestInstall {
    node 'localhost' {
        MyTelnetInstall MyTelnetTest {
            Ensure = 'Present'
        }
    }
}

break
mkdir C:\DSC
cd C:\DSC
MyFinalConfig -output c:\DSC -ConfigurationData C:\DSC\ConfigData.psd1
#-ComputerName localhost
#-FeatureName XPS-Viewer
#-ConfigurationData C:\DSC\ConfigData.psd1
#Load ConfigData into $a; $a.AllNodes[0].NodeName, of [1].NodeName
ii C:\DSC
notepad C:\DSC\localhost.mof
Start-DscConfiguration -Path C:\DSC -Wait -Verbose
Get-WindowsFeature Telnet-Client
Get-WindowsFeature XPS-Viewer
