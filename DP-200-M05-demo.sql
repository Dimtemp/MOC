-- Storage account name:
-- Storage account key:
-- SSMS Client IP:
-- DW FQDN:



-- 1_Create_Database.sql
CREATE DATABASE DWDB COLLATE SQL_Latin1_General_CP1_CI_AS
(
	EDITION			= 'DataWarehouse'
,	SERVICE_OBJECTIVE 	= 'DW100c'
,	MAXSIZE 		= 1024 GB
);
GO



USE DWDB;
GO



-- 1_Creating Tables.sql
CREATE TABLE [dbo].[Users](
	[UserId] [int]  NULL,
	[City] [nvarchar](100) NULL,
	[Region] [nvarchar](100) NULL,
	[Country] [nvarchar](100) NULL
) 
WITH
(
	CLUSTERED COLUMNSTORE INDEX
,	DISTRIBUTION = REPLICATE
)
;

CREATE TABLE [dbo].[Product](
	[ProductId] [int] NULL,
	[EnglishProductName] [nvarchar](100) NULL,
	[Color] [nvarchar](100) NULL,
	[StandardCost] [int]  NULL,
	[ListPrice] [int]  NULL,
	[Size] [nvarchar](100) NULL,
	[Weight] [int]  NULL,
	[DaysToManufacture] [int]  NULL,
	[Class] [nvarchar](100) NULL,
	[Style] [nvarchar](100) NULL
) 

WITH
(
	CLUSTERED COLUMNSTORE INDEX
,	DISTRIBUTION = ROUND_ROBIN
)
;

CREATE TABLE [dbo].[FactSales](
	[DateId] [int] NULL,
	[ProductId] [int] NULL,
	[UserId] [int] NULL,
	[UserPreferenceId] [int] NULL,
	[SalesUnit] [int] NULL
) 
WITH
(
	CLUSTERED COLUMNSTORE INDEX
,	DISTRIBUTION = HASH([SalesUnit])
)
;


/*CLeanup
DROP TABLE [dbo].[User];
DROP TABLE [dbo].[Product];
DROP TABLE [dbo].[FactSales];
*/




-- 1_Polybase_Load.sql
-- Create a master key.
-- Only necessary if one does not already exist.
-- Required to encrypt the credential secret in the next step.

CREATE MASTER KEY;


-- Create a database scoped credential
-- IDENTITY: Provide any string, it is not used for authentication to Azure storage.
-- SECRET: Provide your Azure storage account key.


CREATE DATABASE SCOPED CREDENTIAL AzureStorageCredential
WITH
    IDENTITY = 'MOCID',
    SECRET = 'PasteYourStorageAccountAccessKey1'
;


-- Create an external data source
-- TYPE: HADOOP - PolyBase uses Hadoop APIs to access data in Azure blob storage.
-- LOCATION: Provide Azure storage account name and blob container name.
-- CREDENTIAL: Refer to the credential created in the previous step.

CREATE EXTERNAL DATA SOURCE AzureStorage
WITH (
    TYPE = HADOOP,
    LOCATION = 'wasbs://data@YourStorageAccountName.blob.core.windows.net',
    CREDENTIAL = AzureStorageCredential
);


-- D: Create an external file format
-- FORMAT_TYPE: Type of file format in Azure storage (supported: DELIMITEDTEXT, RCFILE, ORC, PARQUET).
-- FORMAT_OPTIONS: Specify field terminator, string delimiter, date format etc. for delimited text files.
-- Specify DATA_COMPRESSION method if data is compressed.

CREATE EXTERNAL FILE FORMAT TextFile
WITH (
    FORMAT_TYPE = DelimitedText,
    FORMAT_OPTIONS (FIELD_TERMINATOR = ',')
);


-- E: Create the external table
-- Specify column names and data types. This needs to match the data in the sample file.
-- LOCATION: Specify path to file or directory that contains the data (relative to the blob container).
-- To point to all files under the blob container, use LOCATION='.'

CREATE EXTERNAL TABLE dbo.DimDate2External (
	[Date] datetime2(3) NULL,
	[DateKey] decimal(38, 0) NULL,
	[MonthKey] decimal(38, 0) NULL,
	[Month] nvarchar(100) NULL,
	[Quarter] nvarchar(100) NULL,
	[Year] decimal(38, 0) NULL,
	[Year-Quarter] nvarchar(100) NULL,
	[Year-Month] nvarchar(100) NULL,
	[Year-MonthKey] nvarchar(100) NULL,
	[WeekDayKey] decimal(38, 0) NULL,
	[WeekDay] nvarchar(100) NULL,
	[Day Of Month] decimal(38, 0) NULL
)
WITH (
    LOCATION='/DimDate2.txt',
    DATA_SOURCE=AzureStorage,
    FILE_FORMAT=TextFile
);


-- Run a query on the external table

SELECT count(*) FROM dbo.DimDate2External;

SELECT * FROM dbo.DimDate2External;

-- Load the data from Azure blob storage to SQL Data Warehouse

CREATE TABLE dbo.Dates
WITH
(   
    CLUSTERED COLUMNSTORE INDEX,
    DISTRIBUTION = ROUND_ROBIN
)
AS
SELECT * FROM [dbo].[DimDate2External];


-- Create statistics on the new data

CREATE STATISTICS [DateKey] on [Dates] ([DateKey]);
CREATE STATISTICS [Quarter] on [Dates] ([Quarter]);
CREATE STATISTICS [Month] on [Dates] ([Month]);


-- Query the dbo.dates table

SELECT * FROM dbo.Dates;

