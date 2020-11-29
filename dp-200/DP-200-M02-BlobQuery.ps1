$ResourceGroupName = 'DP200x929'

Get-AzProviderFeature -ProviderNamespace Microsoft.Storage -FeatureName BlobQuery
# optionally
Register-AzProviderFeature -ProviderNamespace Microsoft.Storage -FeatureName BlobQuery

$Keys = Get-AzStorageAccountKey -ResourceGroupName 'DP200' -Name $ResourceGroupName

$t = New-TemporaryFile

$inputconfig = New-AzStorageBlobQueryConfig -AsJson -RecordSeparator "`n"

$ctx = New-AzStorageContext -StorageAccountName $ResourceGroupName -StorageAccountKey $Keys.Value[0]  # -Anonymous

$HashArguments = @{
    Container = 'logs'
    Blob = 'preferences.json'
    QueryString = 'SELECT * FROM BlobStorage'
    InputTextConfiguration = $inputconfig
    ResultFile = $t
    Context = $ctx
}

Get-AzStorageBlobQueryResult @HashArguments
# -OutputTextConfiguration (New-AzStorageBlobQueryConfig -AsCsv -HasHeader) -ResultFile $tempfile.FullName -Force


<#
More information
https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-query-acceleration-how-to
#>
