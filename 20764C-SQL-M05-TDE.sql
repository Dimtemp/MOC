-- Prepare the Demo directory
EXEC xp_create_subdir 'C:\Demo'

-- Prepare the SQL Instance
USE master

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pa$$w0rd'
BACKUP MASTER KEY TO FILE = 'C:\Demo\Master.key' ENCRYPTION BY PASSWORD = 'Password2'

CREATE CERTIFICATE MyServerCert WITH SUBJECT = 'DEK_Certificate'
BACKUP CERTIFICATE MyServerCert TO FILE = 'C:\Demo\MyServerCert.cer' -- ENCRYPTION BY PASSWORD='Password3'

-- Create two databases, one not encrypted, one encrypted
CREATE DATABASE Sales    ON ( NAME = Sales_dat,    FILENAME = 'C:\Demo\Sales_dat.mdf' )
CREATE DATABASE SalesTDE ON ( NAME = SalesTDE_dat, FILENAME = 'C:\Demo\SalesTDE_dat.mdf' )

-- fill with data
USE Sales
CREATE TABLE Table1 (col1 nvarchar(600));
GO
INSERT INTO Table1 (col1) values ('greetings');
GO 50

SELECT * FROM Table1


USE SalesTDE
CREATE TABLE Table1 (col1 nvarchar(600));
GO
INSERT INTO Table1 (col1) values ('greetings');
GO 50
SELECT * FROM Table1

CREATE DATABASE ENCRYPTION KEY WITH ALGORITHM = AES_256 ENCRYPTION BY SERVER CERTIFICATE MyServerCert

USE master
ALTER DATABASE SalesTDE SET ENCRYPTION ON  -- or by GUI in DB Properties

EXEC sp_detach_db 'Sales', 'true';
EXEC sp_detach_db 'SalesTDE', 'true';

-- Open PowerShell v5+
-- Format-Hex -Path C:\Demo\Salesdat.mdf    | Select-Object -First 40
-- Format-Hex -Path C:\Demo\SalesTDEdat.mdf | Select-Object -First 40
