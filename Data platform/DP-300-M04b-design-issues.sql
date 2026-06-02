USE AdventureWorks2017;

SELECT * FROM HumanResources.Employee WHERE NationalIDNumber = 14417807
-- inspect the Execution Plan


DROP INDEX [AK_Employee_NationalIDNumber] ON [HumanResources].[Employee];
GO

ALTER TABLE [HumanResources].[Employee] ALTER COLUMN [NationalIDNumber] INT NOT NULL;
GO

CREATE UNIQUE NONCLUSTERED INDEX [AK_Employee_NationalIDNumber] ON [HumanResources].[Employee] ( [NationalIDNumber] ASC);
GO
