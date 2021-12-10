# enable DSC log
wevtutil.exe set-log "Microsoft-Windows-Dsc/Analytic" /q:true /e:true
# don't forget to enable Debug and Analytical logs in EventVwr

# inspect service
Get-WmiObject win32_service | where name -match wu

# inspect telnet client
Get-WindowsFeature t*

# inspect resource syntax
Get-DscResource -Name File -Syntax   # ook met o.a. group


Configuration DscResourceTest {
    Import-DscResource –ModuleName  'PSDesiredStateConfiguration'
      Node localhost {

        Archive ArchiveExample {
            Ensure = 'Present'
            Path = "C:\DscTest\Test.zip"
            Destination = "C:\DscTest\ExtractionPath"
        }

        Environment EnvironmentExample
        {
            Ensure = 'Present'
            Name = "DSCEnvironmentVariable"
            Value = "TestValue"
        }

        File DirectoryCopy
        {
             Ensure = "Present"
             Type = "Directory" # Default is "File".
             Recurse = $true
             SourcePath = "C:\DscTest\DemoSource"
             DestinationPath = "C:\DscDestination\"
        }
    
        Log LogExample
        {
            Message = 'message for Microsoft-Windows-Desired State Configuration/Analytic event log'
        }

        Package PackageExample
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = "$Env:SystemDrive\DscTest\7zip.msi"
            Name = '7-zip'
            ProductId = "ACDDCDAF-80C6-41E6-A1B9-8ABD8A05027E"
        }

        Registry RegistryExample
        {
            Ensure = 'Present'
            Key = 'HKEY_LOCAL_MACHINE\SOFTWARE\DscTestKey'
            ValueName = 'TestValue'
            ValueData = 123
        }


        Script ScriptExample
        {
            SetScript = {
                # from 55202 demo
                $sw = New-Object System.IO.StreamWriter("C:\DscTest\TestFile.txt")
                $sw.WriteLine("Some sample string")
                $sw.Close()
            }
            TestScript = {
                Test-Path "C:\DscTest\TestFile.txt" 
            }
            GetScript = { <# This must return a hash table #> }         
        }

        Service ServiceExample
        {
            Name = 'wuauserv'
            StartupType = 'Manual'
            State = 'Running'
        }

        User UserExample
        {
            Ensure = 'Present'
            UserName = 'DscUser'
            #Password = $passwordCred
            DependsOn = '[Group]GroupExample'
        }


        Group GroupExample
        {
            Ensure = 'Present'
             GroupName = 'DscGroup'
             Description = 'DSC test group'
            #members
            #MembersToInclude
         }


        WindowsFeature RoleExample
        {
            Ensure = 'Present'
            Name = 'telnet-client'
        }

        WindowsProcess Notepad
        {
            Arguments = '-d'
            Path = 'notepad.exe'
            Ensure = 'Present'
            # WorkingDirectory = 'c:\'
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
