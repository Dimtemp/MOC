-- Create a table with a primary key
CREATE TABLE dbo.PhoneLog
( PhoneLogID int IDENTITY(1,1) PRIMARY KEY,
  LogRecorded datetime2 NOT NULL,
  PhoneNumberCalled nvarchar(100) NOT NULL,
  CallDurationMs int NOT NULL
);
GO

-- Insert some data into the table
SET NOCOUNT ON;
DECLARE @Counter int = 0;
WHILE @Counter < 10000 BEGIN
  INSERT dbo.PhoneLog (LogRecorded, PhoneNumberCalled, CallDurationMs)
    VALUES(SYSDATETIME(),'999-9999',CAST(RAND() * 1000 AS int));
  SET @Counter += 1;
END;
GO

-- Include the actual execution plan by pressing Ctrl-M

-- Retrieve the data and inspect the execution plan
SELECT * FROM PhoneLog
WHERE CallDurationMs = 10

-- Create an index
CREATE NONCLUSTERED INDEX MyIndex ON PhoneLog ( CallDurationMs ASC )

-- Retrieve the data and inspect the execution plan
SELECT * FROM PhoneLog
WHERE CallDurationMs = 10

-- Drop the index
DROP INDEX MyIndex ON PhoneLog
