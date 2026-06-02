-- Create a table with a primary key
CREATE TABLE dbo.PhoneLog
( PhoneLogID int IDENTITY(1,1) PRIMARY KEY,
  LogRecorded datetime2 NOT NULL,
  PhoneNumberCalled nvarchar(100) NOT NULL,
  CallDurationSec int NOT NULL
);
GO

-- Insert some data into the table
SET NOCOUNT ON;
DECLARE @Counter int = 0;
WHILE @Counter < 10000 BEGIN
  INSERT dbo.PhoneLog (LogRecorded, PhoneNumberCalled, CallDurationSec)
    VALUES(SYSDATETIME(),'999-9999',CAST(RAND() * 1000 AS int));
  SET @Counter += 1;
END;
GO

-- Include the actual execution plan by pressing Ctrl-M

-- Retrieve the data and inspect the execution plan
-- You might want to change the value to retrieve actual results
SELECT * FROM dbo.PhoneLog
WHERE CallDurationSec = 991

-- Create an index
CREATE NONCLUSTERED INDEX MyIndex ON dbo.PhoneLog ( CallDurationSec ASC )

-- Retrieve the data and inspect the execution plan
SELECT * FROM dbo.PhoneLog
WHERE CallDurationSec = 991

-- Drop the index
DROP INDEX MyIndex ON dbo.PhoneLog

-- Drop the table
DROP TABLE dbo.PhoneLog
