function Compare-ADGroupWithCMCollectionMember {

<#
.SYNOPSIS
This function compares the members of an AD group with the members of a SCCM Collection.

.DESCRIPTION
Run this script on a system with the SCCM module and the ActiveDirectory module present.

.Notes
by Dimitri Koens

15-03-2019: Initial Version.

#>
    param(
        [Parameter(Mandatory=$true)]        
        [string]$ADGroupName,

        [Parameter(Mandatory=$true)]
        [string]$CMCollectionName
    )

    $UsersFromCollection = Get-CMCollectionMember -CollectionName $CMCollectionName |
        Select-Object @{Name='SamAccountName'; Expression={$_.SMSID.split('\')[1]}}

    $MembersFromAD = Get-ADGroupMember -Identity $ADGroupName

    Compare-Object $MembersFromAD $UsersFromCollection -Property SamAccountName
}

Compare-ADGroupWithCMCollectionMember -ADGroupName 'marketing' -cm 'marketing users'
