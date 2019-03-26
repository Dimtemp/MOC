-- Prepare the Demo directory
EXEC xp_create_subdir 'C:\Demo'

--Create a database master key 
USE master
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pa$$w0rd';
-- OPEN MASTER KEY DECRYPTION BY PASSWORD = 'Pa$$w0rd';
BACKUP MASTER KEY TO FILE = 'C:\Demo\master.key'
ENCRYPTION BY PASSWORD = 'Pa55w.rd';

SELECT * FROM sys.symmetric_keys;


-- Create Demo database
CREATE DATABASE Demo ON ( NAME = Demo_dat, FILENAME = 'C:\Demo\Demo_dat.mdf' )

USE Demo
CREATE TABLE Table1 (col1 nvarchar(600));
GO
INSERT INTO Table1 (col1) values ('greetings');
GO 1000

SELECT * FROM Table1

--Create a certificate
CREATE CERTIFICATE DemoCert
WITH SUBJECT = 'Demo Certificate';

--Backup the certificate and its private key
BACKUP CERTIFICATE AdventureWorksCert 
TO FILE = 'C:\Demo\DemoCert.cer'
WITH PRIVATE KEY ( file = 'D:\Backups\DemoCert.pvk' ,
encryption by password = 'Sqlserver2016@');
GO

-- Backup database
BACKUP DATABASE Demo
WITH 
ENCRYPTION (ALGORITHM = AES_256)
--, -- or AES_128 | AES_192 | TRIPLE_DES_3KEY
--SERVER CERTIFICATE = Encryptor_Name | SERVER ASYMMETRIC KEY = Encryptor_Name
