

Get-AzProviderFeature -ProviderNamespace Microsoft.Storage -FeatureName BlobQuery
# optionally
Register-AzProviderFeature -ProviderNamespace Microsoft.Storage -FeatureName BlobQuery

$Key1 = "hXgQU1iilx9MkdCrtJZEyLu9ts0NfO8ea46lCkE7s4MOFXNV09w7bA0xid2IsACuhhPavnYR19eeYixUKH8o7w=="

$t = New-TemporaryFile

$inputconfig = New-AzStorageBlobQueryConfig -AsJson -RecordSeparator "`n"

$ctx = New-AzStorageContext -StorageAccountName 'dp200x929' -StorageAccountKey $Key1  # -Anonymous

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
