-- Prepare the Demo directory
EXEC xp_create_subdir 'C:\LogTest'

-- Create database
CREATE DATABASE LogTest
ON ( NAME = LogTest_dat, FILENAME = 'C:\LogTest\LogTest_dat.mdf' )
GO
USE LogTest
GO
CREATE TABLE Table1 (col1 varchar(20))
GO

-- Perform a full database backup
BACKUP DATABASE LogTest
TO DISK = 'C:\LogTest\LogTest.bak'
GO

-- View log file space
DBCC SQLPERF(logspace) 

-- Insert data
INSERT Table1(col1) VALUES('greetings'); 
GO 10000
-- can take up to 50 sec

-- View log file space
DBCC SQLPERF(logspace) 

-- Issue checkpoint
CHECKPOINT

-- View log file space
DBCC SQLPERF(logspace) 

-- Check log status
SELECT name, recovery_model_desc, log_reuse_wait_desc
FROM sys.databases
WHERE name = 'LogTest'

-- Perform a log backup
BACKUP LOG LogTest
TO DISK = 'C:\LogTest\LogTest.trn';
GO

-- Check log status
SELECT name, recovery_model_desc, log_reuse_wait_desc
FROM sys.databases
WHERE name = 'LogTest'

-- Verify log file truncation
DBCC SQLPERF(logspace)
-- note the reduced Log Space Used (%)
