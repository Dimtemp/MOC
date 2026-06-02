$DestDir = 'C:\WideWorldImporters'

$DBSource = 'https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Full.bak'
$DBFilename = Split-Path $DBSource -Leaf
$DBName = 'WideWorldImporters'

$Query = "RESTORE DATABASE $DBName FROM DISK = '$(Join-Path $DestDir $DBFilename)' WITH "
$Query +=   "MOVE 'WWI_Primary'         TO '$(Join-Path $DestDir 'wwi.mdf')'"
$Query += ", MOVE 'WWI_UserData'        TO '$(Join-Path $DestDir 'wwi_userdata.mdf')'"
$Query += ", MOVE 'WWI_Log'             TO '$(Join-Path $DestDir 'wwi_log.ldf')'"
$Query += ", MOVE 'WWI_InMemory_Data_1' TO '$(Join-Path $DestDir 'wwi_inmemory')', REPLACE;"
Write-Host $Query

$Activity = 'Preparing DP-300 demo env'

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12   # not required for w2019
mkdir $DestDir
mkdir (Join-Path $DestDir 'wwi_inmemory')

Write-Progress -Activity $Activity -Status "Downloading $DBName"
Start-BitsTransfer -Source $DBSource -destination 

Write-Progress -Activity $Activity -Status 'Restoring database'
Invoke-Sqlcmd -Query $Query

Write-Progress -Activity $Activity -Completed
