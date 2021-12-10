# Prep
# enable DSC log
wevtutil.exe set-log "Microsoft-Windows-Dsc/Analytic" /q:true /e:true
# don't forget to enable Debug and Analytical logs in EventVwr

mkdir C:\DscTest

# zip some files in C:\DscTest\ArchiveTest.zip

# inspect service
Get-WmiObject win32_service | where name -match wuauserv

# inspect telnet client
Get-WindowsFeature t*

# inspect resource syntax
Get-DscResource -Name User -Syntax   # demo file, group, user, ...


Configuration DscResourceTest {
    Import-DscResource –ModuleName 'PSDesiredStateConfiguration'
      Node localhost {

        Archive ArchiveExample {
            Ensure = 'Present'
            Path = 'C:\DscTest\ArchiveTest.zip'
            Destination = 'C:\DscTest\ExtractionPath'
        }

        Environment EnvironmentExample {
            Ensure = 'Present'
            Name = 'DSCEnvironmentVariable'
            Value = 'DscValue'
        }


        File DirectoryCopy {
             Ensure = 'Present'
             Type = 'File'   # Default is 'File'
             Recurse = $false
             SourcePath = 'C:\Windows\win.ini'
             DestinationPath = 'C:\DscTest\Destination\'
             #MatchSource = $true
        }
    
        Log LogExample {
            Message = 'message for Microsoft-Windows-Desired State Configuration/Analytic event log'
        }


        Package PackageExample {
            Ensure = 'Present'
            Path  = 'C:\DscTest\7z2106-x64.msi'
            Name = '7-Zip 21.06 (x64 edition)'
            ProductId = '23170F69-40C1-2702-2106-000001000000'
            DependsOn = '[Script]ScriptExample'
        }


        Registry RegistryExample {
            Ensure = 'Present'
            Key = 'HKEY_LOCAL_MACHINE\SOFTWARE\DscTestKey'
            ValueName = 'TestValue'
            ValueData = 123
        }


        Script ScriptExample {
            SetScript = {
                # download 7zip
                Invoke-WebRequest -UseBasicParsing -Uri 'https://www.7-zip.org/a/7z2106-x64.msi' -OutFile 'C:\DscTest\7z2106-x64.msi'
            }
            TestScript = {
                Test-Path 'C:\DscTest\7z2106-x64.msi'
            }
            GetScript = {
                <# This must return a hash table #>
            } 
        }

        Service ServiceExample {
            Name = 'wuauserv'
            StartupType = 'Automatic'
            State = 'Running'
        }


        Group GroupExample {
            Ensure = 'Present'
            GroupName = 'DscGroup'
            Description = 'DSC test group'
            Members = 'DscUser'
            #MembersToInclude
            DependsOn = '[User]UserExample'
        }


        User UserExample {
            Ensure = 'Present'
            UserName = 'DscUser'
            Description = 'DSC test user'
            #Password = $passwordCred
            #DependsOn = '[Group]GroupExample'
        }


        WindowsFeature RoleExample {
            Ensure = 'Present'
            Name = 'telnet-client'
        }

        WindowsProcess ProcessExample {
            Path = 'notepad.exe'
            Arguments = '-d'
            Ensure = 'Present'
            # WorkingDirectory = 'c:\'
        }
    }
}   # SecondTestConfig


# run it
DscResourceTest -output c:\DscTest
Start-DscConfiguration c:\DscTest -Wait -Verbose -Force


# inspect
Get-ChildItem HKLM:\SOFTWARE   # or regedit.exe
Get-WmiObject win32_service | where name -match wuauserv
Get-WindowsFeature t*
Get-LocalUser
Get-LocalGroup | Sort
Get-LocalGroupMember DscGroup
EventVwr
