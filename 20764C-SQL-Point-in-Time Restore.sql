-- Prepare the Demo directory
EXEC xp_create_subdir 'C:\Demo'

--Create a database and back it up
CREATE DATABASE BackupDemo ON ( NAME = BackupDemo_dat, FILENAME = 'C:\Demo\BackupDemo_dat.mdf' )
GO
USE BackupDemo
GO
CREATE TABLE Customers (
 FirstName nvarchar(50),
 LastName nvarchar(50))
GO
BACKUP DATABASE [BackupDemo] TO  DISK = 'C:\Demo\BackupDemo.bak'
WITH FORMAT, INIT,  NAME = 'BackupDemo Database Backup', COMPRESSION
GO

-- Enter some data
INSERT INTO BackupDemo.dbo.Customers
VALUES ('Dan', 'Drayton')
GO

-- Get the current time
SELECT getdate()
-- note the exact current time: ________________

-- Enter some more data
INSERT INTO BackupDemo.dbo.Customers
VALUES ('Joan', 'Chambers')
GO

-- inspect the Customers table
SELECT * FROM BackupDemo.dbo.Customers


--Back up the transaction log
BACKUP LOG [BackupDemo] TO  DISK = 'C:\Demo\BackupDemo.bak'
WITH NOFORMAT, NOINIT,  NAME = 'BackupDemo Log Backup', COMPRESSION
GO

-- optionally inspect backup history in msdb
SELECT * FROM msdb.dbo.backupset

-- now perform point in time restore in the GUI

-- or perform a tail-log backup and restore with TSQL
USE [master]
BACKUP LOG [BackupDemo] TO  DISK = 'C:\Demo\BackupDemo_LogBackup_2019-03-27_04-00-40.bak' WITH NOFORMAT, NOINIT,  NAME = N'BackupDemo_LogBackup_2019-03-27_04-00-40', NOSKIP, NOREWIND, NOUNLOAD,  NORECOVERY ,  STATS = 5
RESTORE DATABASE [BackupDemo] FROM  DISK = N'C:\Demo\BackupDemo.bak' WITH  FILE = 1,  NOUNLOAD,  STATS = 5
GO



