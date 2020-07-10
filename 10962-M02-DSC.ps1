Configuration SecondTestConfig {
      Node localhost {

        Group GroupExample
        {
            # This will create TestGroup
            Ensure = "Present"
             GroupName = "TestGroup"
             Description = 'dsc test group'
        }

        Log LogExample
        {
            Message = "message for Microsoft-Windows-Desired State Configuration/Analytic event log"
        }

        Registry RegistryExample
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Key = "HKEY_LOCAL_MACHINE\SOFTWARE\ExampleKey"
            ValueName = "TestValue"
            ValueData = "TestData"
        }

        WindowsFeature RoleExample
        {
            Ensure = "Present" # Alternatively, to ensure the role is uninstalled, set Ensure to "Absent"
            Name = "telnet-client" # Use the Name property from Get-WindowsFeature 
        }

        Service ServiceExample
        {
            Name = "wuauserv"
            StartupType = "Manual"
            State = "Running"
        }

     }   # localhost
}   # SecondTestConfig
