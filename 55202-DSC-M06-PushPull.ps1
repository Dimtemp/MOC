# to do: trusted hosts, so no need for VM to be member of domain

### STARTER ##############################################
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# this module can configure a pull server using DSC
Install-Module -Name xPSDesiredStateConfiguration -RequiredVersion 3.13.0.0
# optionally: Register-PSRepository -Default / Install-PackageProvider nuget


### Create pull server #################################

configuration Sample_xDscWebService 
{ 
    param  
    ( 
            [string[]]$NodeName = 'localhost', 

            [Parameter(HelpMessage='Use AllowUnencryptedTraffic for setting up a non SSL based endpoint (Recommended only for test purpose)')]
            [ValidateNotNullOrEmpty()] 
            [string] $certificateThumbPrint,

            [Parameter(HelpMessage='This should be a string with enough entropy (randomness) to protect the registration of clients to the pull server.  We will use new GUID by default.')]
            [ValidateNotNullOrEmpty()]
            [string] $RegistrationKey = ([guid]::NewGuid()).Guid
     ) 


     Import-DSCResource -ModuleName xPSDesiredStateConfiguration -ModuleVersion 3.13.0.0
     Import-DSCResource -ModuleName PSDesiredStateConfiguration 

     Node $NodeName 
     { 
         WindowsFeature DSCServiceFeature 
         { 
             Ensure = "Present" 
             Name   = "DSC-Service"             
         } 


         xDscWebService PSDSCPullServer 
         { 
             Ensure                  = "Present" 
             EndpointName            = "PSDSCPullServer" 
             Port                    = 8086 
             PhysicalPath            = "$env:SystemDrive\inetpub\PSDSCPullServer" 
             CertificateThumbPrint   = "AllowUnencryptedTraffic"          
             ModulePath              = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules" 
             ConfigurationPath       = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration"             
             State                   = "Started" 
             DependsOn               = "[WindowsFeature]DSCServiceFeature"                         
         } 

        File RegistrationKeyFile
        {
            Ensure          ='Present'
            Type            = 'File'
            DestinationPath = "$env:ProgramFiles\WindowsPowerShell\DscService\RegistrationKeys.txt"
            Contents        = $RegistrationKey
        }
    }
}

Sample_xDscWebService -certificateThumbPrint "AllowUnencryptedTraffic" -OutputPath C:\Demo\NoCert
Start-DscConfiguration -Path C:\Demo\NoCert -Wait -Verbose -Force


# optionally open mentioned URL or perform Invoke-RestMethod


# Verify RefreshMode: PUSH
Get-DscLocalConfigurationManager


# retrieve key
Get-Content $env:ProgramFiles\WindowsPowerShell\DscService\RegistrationKeys.txt | Set-Clipboard




### Setting up a Pull Client  ###################################

[DSCLocalConfigurationManager()]      
configuration LocalHostLCMConfig
{
    Node StudentServer2
    {
        Settings
        {
            RefreshMode          = 'Pull'
            RefreshFrequencyMins = 30 
            RebootNodeIfNeeded   = $true
        }

        ConfigurationRepositoryWeb StudentServer2    # Use the name of your server                       
        {
            ServerURL          = 'http://StudentServer2:8086/PSDSCPullServer.svc'
            RegistrationKey    = '4397a84c-5765-41bf-b91b-a8f2d3d740a1'      # REPLACE
            ConfigurationNames = @('StudentServer2')
            AllowUnsecureConnection = $true
        }   

        ReportServerWeb StudentServer2    # Use the name of your server                                  
        {
            ServerURL       = 'http://StudentServer2:8086/PSDSCPullServer.svc'
            RegistrationKey = '4397a84c-5765-41bf-b91b-a8f2d3d740a1'         # REPLACE
            AllowUnsecureConnection = $true
        }
    }
}

LocalHostLCMConfig  -OutputPath c:\Configs\TargetNodes  

Set-DscLocalConfigurationManager -Path C:\Configs\TargetNodes\ -Verbose -Force
# response: Registration ... failed ... Unauthorized: don't forget to replace keys.


# Verify RefreshMode: Pull
Get-DscLocalConfigurationManager






### DISTRIBUTE ##############################################

$configData = @{
    AllNodes = @(
        @{
            NodeName = 'StudentServer2'                      
        }
    )    
}


Configuration SampleLog {
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    node $AllNodes.Nodename
    {
        Log SampleMessage
        {
            Message = 'Sample Message'
        }

        File SampleFile
        {
        Ensure          = 'Present'
        Type            = 'Directory'
        DestinationPath = 'C:\MyDemoDirectory\'
        }
    }
}

SampleLog -ConfigurationData $configData -outputpath C:\Holding\Configurations\
New-DscChecksum -Path C:\Holding\Configurations\ -Force

# inspect output folder
Get-ChildItem C:\Holding\Configurations

# move files to DSC Service
Get-ChildItem C:\Holding\Configurations -File | foreach { Move-Item -Path $_.FullName -Destination $env:ProgramFiles\WindowsPowerShell\DscService\Configuration\ }

# inspect
Invoke-Item $env:ProgramFiles\WindowsPowerShell\DscService\Configuration\


# Update the configuration
Update-DscConfiguration -Verbose -Wait
# review sample message



### DSC Fixes Things

Get-DscLocalConfigurationManager
# verify ConfigurationMode: ApplyAndMonitor


[DSCLocalConfigurationManager()]      
configuration LocalHostLCMConfig
{
    Node StudentServer2
    {
        Settings
        {
            RefreshMode          = 'Pull'
            RefreshFrequencyMins = 30 
            RebootNodeIfNeeded   = $true
            ConfigurationMode    = 'ApplyAndAutocorrect'   # notice!
        }

        ConfigurationRepositoryWeb StudentServer2
        {
            ServerURL          = 'http://StudentServer2:8086/PSDSCPullServer.svc'
            RegistrationKey    = '4397a84c-5765-41bf-b91b-a8f2d3d740a1'      # REPLACE
            ConfigurationNames = @('StudentServer2')
            AllowUnsecureConnection = $true
        }

        ReportServerWeb StudentServer2
        {
            ServerURL       = 'http://StudentServer2:8086/PSDSCPullServer.svc'
            RegistrationKey = '4397a84c-5765-41bf-b91b-a8f2d3d740a1'         # REPLACE
            AllowUnsecureConnection = $true
        }
    }
}

LocalHostLCMConfig  -OutputPath c:\Configs\TargetNodes  

Set-DscLocalConfigurationManager -Path C:\Configs\TargetNodes\ -Verbose -Force
Get-DscLocalConfigurationManager



### DISTRIBUTE

$configData = @{
    AllNodes = @(
        @{
            NodeName = 'StudentServer2'                      
        }
    )    
}

Configuration SampleLog
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    node $AllNodes.Nodename
    {
        Log SampleMessage
        {
            Message = 'Another Sample Message'
        }

        File SampleFile
        {
            Ensure = 'Present'
            Type = 'Directory'
            DestinationPath = 'C:\MyDemoDirectory\'
        }
    }
}

SampleLog -ConfigurationData $configData -outputpath C:\Holding\Configurations\ 
New-DscChecksum -Path C:\Holding\Configurations\ -Force

# inspect output folder
Get-ChildItem C:\Holding\Configurations

# move files to DSC Service and overwrite
Get-ChildItem C:\Holding\Configurations -File | foreach { Move-Item -Path $_.FullName -Destination $env:ProgramFiles\WindowsPowerShell\DscService\Configuration\ -Force }

# inspect
Invoke-Item $env:ProgramFiles\WindowsPowerShell\DscService\Configuration\



# You must move the files to the Configuration folder before executing the next line.
Update-DscConfiguration -Verbose -Wait


# inspect folder
Get-ChildItem C:\ -Directory

# test current config
Test-DscConfiguration -Verbose
# notice: no action is required

# remove folder
Remove-Item C:\MyDemoDirectory

# test current config
Test-DscConfiguration -Verbose
# notice: system cannot find the file specified

Update-DscConfiguration -Verbose -Wait
# checksum didn't change, so we need to wait the minimum interval (15 min) for Dsc to run again



### DEBUG ###########################################################

Enable-DscDebug -BreakAll
$MyLcm = Get-DscLocalConfigurationManager
$MyLcm.DebugMode

#Test Configuration 
Configuration PSEngine2
{
    Import-DscResource -ModuleName 'PsDesiredStateConfiguration'
    Node localhost
    {
        WindowsFeature PSv2
        {
            Name = 'PowerShell-v2'
            Ensure = 'Present'
        }
    }
}
PSEngine2 -outputpath 'C:\Demo\Debug'
Start-DscConfiguration -Path C:\Demo\Debug -Wait  -Verbose -Force # Using -Force because LCM is configured for Pull
