# enable DSC log
wevtutil.exe set-log "Microsoft-Windows-Dsc/Analytic" /q:true /e:true
# don't forget to enable Debug and Analytical logs in EventVwr

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

        Archive ArchiveExample {
            Ensure = "Present"
            Path = "C:\Users\Public\Documents\Test.zip"
            Destination = "C:\Users\Public\Documents\ExtractionPath"
        }

        Environment EnvironmentExample
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Name = "DSCTestEnvironmentVariable"
            Value = "TestValue"
        }

        File DirectoryCopy
        {
             Ensure = "Present"
             Type = "Directory" # Default is "File".
             Recurse = $true
             SourcePath = "C:\Users\Public\Documents\DSCDemo\DemoSource"
             DestinationPath = "C:\Users\Public\Documents\DSCDemo\DemoDestination"   
        }
    
        Group GroupExample
        {
            Ensure = 'Present'
             GroupName = 'TestGroup'
             Description = 'DSC test group'
            #members
            #MembersToInclude
         }

        Log LogExample
        {
            Message = 'message for Microsoft-Windows-Desired State Configuration/Analytic event log'
        }

        Package PackageExample
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path  = "$Env:SystemDrive\TestFolder\TestProject.msi"
            Name = "TestPackage"
            ProductId = "ACDDCDAF-80C6-41E6-A1B9-8ABD8A05027E"
        }

        Registry RegistryExample
        {
            Ensure = 'Present'
            Key = 'HKEY_LOCAL_MACHINE\SOFTWARE\ExampleKey'
            ValueName = 'TestValue'
            ValueData = 123
        }


        Script ScriptExample
        {
            SetScript = {
                $sw = New-Object System.IO.StreamWriter("C:\TempFolder\TestFile.txt")
                $sw.WriteLine("Some sample string")
                $sw.Close()
            }
            TestScript = { Test-Path "C:\TempFolder\TestFile.txt" }
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
            Ensure = "Present"
            UserName = "UserNameExample"
            #Password = $passwordCred
            DependsOn = “[Group]GroupExample"
        }


        WindowsFeature RoleExample
        {
            Ensure = 'Present'
            Name = 'telnet-client'
        }

        WindowsProcess [string] #ResourceName
        {
            Arguments = '-d'
            Path = notepad.exe
            Ensure = Present
            WorkingDirectory = "c:\"
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
