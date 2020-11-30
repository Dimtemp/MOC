function New-AzStorageAccountForDP200Training {
    <#
    .SYNOPSIS
    Creates prerequisite file for module 3 and later from the DP-200 training.
    .NOTES
    Containers & files:
    \data\DimDate2.txt      required for Module 5: SQL and Synapse (DW)
    \logs\preferences.json  required for Module 3: Databricks
    \phonecalls             required for Module 6: stream analytics
    #>

    param(
        $rgName = 'dp200',
        $location = 'westeurope',
        $saName = "dp200x$(Get-Random -Maximum 1000)"
    )

    $containers = 'data', 'logs', 'phonecalls'
    $file1 = 'https://raw.githubusercontent.com/MicrosoftLearning/DP-200-Implementing-an-Azure-Data-Solution/master/Labfiles/Starter/DP-200.2/Static%20files/DimDate2.txt'
    $file2 = 'https://raw.githubusercontent.com/MicrosoftLearning/DP-200-Implementing-an-Azure-Data-Solution/master/Labfiles/Starter/DP-200.2/logs/preferences.json'

    New-AzResourceGroup -Location $location -Name $rgName

    # Check StorageAccountNameAvailability
    $saNameAvailable = Get-AzStorageAccountNameAvailability -Name $saName

    if ($saNameAvailable.NameAvailable)
    {
        # Create storage account, from lab: Std/V2/RA_GRS/Hot/HIERARCHICAL
        $s = New-AzStorageAccount -ResourceGroupName $rgName -Name $saName -SkuName Standard_LRS -Location $location -EnableHierarchicalNamespace $true

        # create containers
        $containers | ForEach-Object { New-AzStorageContainer -Name $_ -Context $s.Context }

        # create files
        Start-AzStorageBlobCopy -DestContext $s.Context -DestContainer 'data' -DestBlob (Split-Path $file1 -Leaf) -AbsoluteUri $file1
        Start-AzStorageBlobCopy -DestContext $s.Context -DestContainer 'logs' -DestBlob (Split-Path $file2 -Leaf) -AbsoluteUri $file2
    }
}


function New-AzRoleAssignmentForDP200Training {
    <#
    .SYNOPSIS
    This function assigns the Storage Blob Data Contributor role to the user-specified principal on the user-specified resource group.
    #>

    param(
        $ResourceGroupName = (Get-AzResourceGroup | Out-GridView -OutputMode Single -Title 'Select the resource group to assign permissions to').ResourceGroupName,
        $RoleName = (Get-AzRoleDefinition -Name 'Storage Blob Data Contributor').Name,
        $SPName = 'dlaccess'
    )
    $id = Get-AzADServicePrincipal | Where-Object displayname -match $SPName
    New-AzRoleAssignment -ObjectId $id.Id -RoleDefinitionName $RoleName -ResourceGroupName $ResourceGroupName
}


function Get-DP200Module3Details {
    <#
    .SYNOPSIS
    This function displays several properties needed for Module 3 of the DP-200 training. To do: display the secret.
    #>

    param(
         $SPName = 'dlaccess'
    )


    $tenant = Get-AzTenant | Out-GridView -OutputMode Single -Title 'Please select the correct tenant'

    $id = Get-AzADServicePrincipal | where displayname -match dlaccess

    $storage = Get-AzStorageAccount | Out-GridView -OutputMode Single -Title 'Please select the correct storage account'

    $keys = Get-AzStorageAccountKey -ResourceGroupName $storage.ResourceGroupName -Name $storage.StorageAccountName

    $properties = @{
        AppId = $id.ApplicationId
        TenantId = $tenant.Id
        Key = $keys.value[0]
    }

    $o = New-Object psobject -Property $properties
    Write-Output $o
}

# Run this command to create a storage account with the correct files required for all modules, except 1 and 2, for the DP-200 training.
# New-AzStorageAccountForDP200Training

# Run this command to get the required details when performing module 3:
# Get-DP200Module3Details | FL

# Run this command to assign permissions to resource group for module 3:
# New-AzRoleAssignmentForDP200Training

