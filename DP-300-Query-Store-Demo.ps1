$DestDir = 'C:\AdventureWorks'
$DBSource = 'https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2017.bak'
$DBName = 'AdventureWorks2017.bak'
$query = "RESTORE DATABASE AdventureWorks2017 FROM DISK = '$(Join-Path $DestDir 'AdventureWorks2017.bak')' WITH MOVE 'AdventureWorks2017' TO '$(Join-Path $DestDir 'AdventureWorks2017.mdf')', MOVE 'AdventureWorks2017_Log' TO '$(Join-Path $DestDir 'AdventureWorks2017_log.ldf')';"
$Activity = 'preparing DP300 demo env'

mkdir $DestDir

Write-Progress -Activity $Activity -Status "Downloading $DBName"
Start-BitsTransfer -Source $DBSource -destination (Join-Path $DestDir $DBName)

Write-Progress -Activity $Activity -Status 'Downloading archive from GitHub'
Start-BitsTransfer -Source 'https://github.com/MicrosoftLearning/DP-300T00-Administering-Relational-Databases-on-Azure/archive/refs/heads/master.zip' -Destination 'C:\AdventureWorks\dp300.zip'

Write-Progress -Activity $Activity -Status 'Expanding archive'
Expand-Archive -Path 'C:\AdventureWorks\dp300.zip' -Destination "$Home\Desktop"

Write-Progress -Activity $Activity -Status 'Restoring database'
Invoke-Sqlcmd -Query $query

Write-Progress -Activity $Activity -Completed
