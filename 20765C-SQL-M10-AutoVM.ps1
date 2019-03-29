workflow AutoVM
{
	Param
    (   
        [Parameter(Mandatory=$true)]
        [String]
        $AzureResourceGroup,
		[Parameter(Mandatory=$true)]
        [Boolean]
		$Shutdown
    )


<#
    .DESCRIPTION
        An example runbook which gets all the ARM resources using the Run As Account (Service Principal)

    .NOTES
        AUTHOR: Azure Automation Team
        LASTEDIT: Mar 14, 2016
#>

$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}

#Get all ARM resources from all resource groups
$ResourceGroups = Get-AzureRmResourceGroup 

foreach ($ResourceGroup in $ResourceGroups)
{    
    Write-Output ("Showing resources in resource group " + $ResourceGroup.ResourceGroupName)
    $Resources = Find-AzureRmResource -ResourceGroupNameContains $ResourceGroup.ResourceGroupName | Select ResourceName, ResourceType
    ForEach ($Resource in $Resources)
    {
        Write-Output ($Resource.ResourceName + " of type " +  $Resource.ResourceType)
    }
    Write-Output ("")
} 

	




    #Connect to your Azure Account   	
#	Add-AzureRmAccount -Credential $Cred
#	Add-AzureAccount -Credential $Cred
	
	if($Shutdown -eq $true){
		Write-Output "Stopping VMs in '$($AzureResourceGroup)' resource group";
	}
	else{
		Write-Output "Starting VMs in '$($AzureResourceGroup)' resource group";
	}
	
	#ARM VMs
	Write-Output "ARM VMs:";
	  
	Get-AzureRmVM -ResourceGroupName $AzureResourceGroup | ForEach-Object {
	
		if($Shutdown -eq $true){
			
				Write-Output "Stopping '$($_.Name)' ...";
				Stop-AzureRmVM -ResourceGroupName $AzureResourceGroup -Name $_.Name -Force;
		}
		else{
			Write-Output "Starting '$($_.Name)' ...";			
			Start-AzureRmVM -ResourceGroupName $AzureResourceGroup -Name $_.Name;			
		}			
	};
	
	
	
	#ASM VMs
	Write-Output "ASM VMs:";
	
	Get-AzureRmResource | where { $_.ResourceGroupName -match $AzureResourceGroup -and $_.ResourceType -eq "Microsoft.ClassicCompute/VirtualMachines"} | ForEach-Object {
		
		$vmName = $_.Name;
		if($Shutdown -eq $true){
			
			Get-AzureVM | where {$_.Name -eq $vmName} | ForEach-Object {
				Write-Output "The machine '$($_.Name)' is $($_.PowerState)";
				
				if($_.PowerState -eq "Started"){
					Write-Output "Stopping '$($_.Name)' ...";		
					Stop-AzureVM -ServiceName $_.ServiceName -Name $_.Name -Force;
				}
			}
		}
		else{
			
			Get-AzureVM | where {$_.Name -eq $vmName} | ForEach-Object {
				Write-Output "The machine '$($_.Name)' is $($_.PowerState)";
								
				if($_.PowerState -eq "Stopped"){
					Write-Output "Starting '$($_.Name)' ...";		
					Start-AzureVM -ServiceName $_.ServiceName -Name $_.Name;
				}
			}
		}		
	};
}

