$DestDir = 'C:\AdventureWorks'
$DBSource = 'https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2017.bak'
$DBName = 'AdventureWorks2017.bak'
$Query = "RESTORE DATABASE AdventureWorks2017 FROM DISK = '$(Join-Path $DestDir 'AdventureWorks2017.bak')' WITH MOVE 'AdventureWorks2017' TO '$(Join-Path $DestDir 'AdventureWorks2017.mdf')', MOVE 'AdventureWorks2017_Log' TO '$(Join-Path $DestDir 'AdventureWorks2017_log.ldf')';"
$Activity = 'preparing DP300 demo env'
$GitSource = 'https://github.com/MicrosoftLearning/dp-300-database-administrator/archive/refs/heads/master.zip'
$GitDest = 'C:\AdventureWorks\dp300.zip'

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12   # not required for w2019
mkdir $DestDir

Write-Progress -Activity $Activity -Status "Downloading $DBName"
Start-BitsTransfer -Source $DBSource -destination (Join-Path $DestDir $DBName)

#Write-Progress -Activity $Activity -Status 'Downloading archive from GitHub'
#Start-BitsTransfer -Source $GitSource -Destination $GitDest

#Write-Progress -Activity $Activity -Status 'Expanding archive'
#Expand-Archive -Path $GitDest -Destination $DestDir

Write-Progress -Activity $Activity -Status 'Restoring database'
Invoke-Sqlcmd -Query $Query

Write-Progress -Activity $Activity -Completed
