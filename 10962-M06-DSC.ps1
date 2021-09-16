# enable DSC log
wevtutil.exe set-log "Microsoft-Windows-Dsc/Analytic" /q:true /e:true

# inspect service
Get-WmiObject win32_service | where name -match wu

# inspect telnet client
Get-WindowsFeature t*

# inspect resource syntax
Get-DscResource -Name File -Syntax
group


Configuration DscResourceTest {
    Import-DscResource –ModuleName  'PSDesiredStateConfiguration'
      Node localhost {

        Group GroupExample
        {
            # This will create TestGroup
            Ensure = 'Present'
             GroupName = 'TestGroup'
             Description = 'DSC test group'
        }

        Log LogExample
        {
            Message = 'message for Microsoft-Windows-Desired State Configuration/Analytic event log'
        }

        Registry RegistryExample
        {
            Ensure = 'Present'
            Key = 'HKEY_LOCAL_MACHINE\SOFTWARE\ExampleKey'
            ValueName = 'TestValue'
            ValueData = 123
        }

        WindowsFeature RoleExample
        {
            Ensure = 'Present'
            Name = 'telnet-client'
        }

        Service ServiceExample
        {
            Name = 'wuauserv'
            StartupType = 'Manual'
            State = 'Running'
        }

     }   # localhost
}   # SecondTestConfig

# run it
DscResourceTest -output c:\DscResourceTest
Start-DscConfiguration c:\DscResourceTest -Wait -Verbose

# inspect
regedit
Get-WmiObject win32_service | where name -match wu
Get-WindowsFeature t*
EventVwr
