-- more info: https://docs.microsoft.com/en-us/sql/relational-databases/security/encryption/encryption-hierarchy

-- Prepare the Demo directory
USE master
EXEC xp_create_subdir 'C:\Demo'
SELECT * FROM sys.symmetric_keys;

--Create a certificate in the master db
CREATE CERTIFICATE DemoCert
WITH SUBJECT = 'Demo Certificate';

--Backup the certificate and its private key
BACKUP CERTIFICATE DemoCert 
TO FILE = 'C:\Demo\DemoCert.cer'
WITH PRIVATE KEY ( file = 'C:\Demo\DemoCert.pvk' ,
ENCRYPTION BY PASSWORD = 'Pa55w.rd');
GO


-- Create Demo database
CREATE DATABASE Demo ON ( NAME = Demo_dat, FILENAME = 'C:\Demo\Demo_dat.mdf' )

USE Demo

CREATE TABLE Table1 (col1 nvarchar(600));
GO
INSERT INTO Table1 (col1) values ('greetings');
GO 1000
SELECT * FROM Table1

--Create a database master key 
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pa$$w0rd';
-- OPEN MASTER KEY DECRYPTION BY PASSWORD = 'Pa$$w0rd';
BACKUP MASTER KEY TO FILE = 'C:\Demo\master.key'
ENCRYPTION BY PASSWORD = 'Pa55w.rd';


-- Backup database unencrypted
BACKUP DATABASE Demo
TO DISK = 'C:\Demo\DemoUnencrypted.bak'

-- Backup database encrypted
BACKUP DATABASE Demo
TO DISK = 'C:\Demo\DemoEncrypted.bak'
WITH INIT, MEDIANAME = 'DemoEncrypted', NAME = 'Demo Encrypted',
ENCRYPTION (
ALGORITHM = AES_256,  -- or AES_128 | AES_192 | TRIPLE_DES_3KEY
SERVER CERTIFICATE = [DemoCert]
)


-- PowerShell
-- $encryptionOption = New-SqlBackupEncryptionOption -Algorithm Aes256 -EncryptorType ServerCertificate -EncryptorName 'DemoCert'
-- Backup-SqlDatabase -ServerInstance . -Database 'Demo' -BackupFile 'C:\Demo\DemoEncrypted.bak' -EncryptionOption $encryptionOption
-- Format-Hex -Path C:\Demo\DemoUnencrypted.bak | Select-Object -First 40
-- Format-Hex -Path C:\Demo\DemoEncrypted.bak   | Select-Object -First 40
