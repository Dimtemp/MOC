DROP TABLE IF EXISTS dbo.EmployeeDemo;
GO

CREATE TABLE dbo.EmployeeDemo
(
    EmployeeID INT NOT NULL,
    FirstName VARCHAR(50),
    LastName VARCHAR(50)
);
GO

INSERT INTO dbo.EmployeeDemo
VALUES
(3,'John','Smith'),
(1,'Jane','Doe'),
(2,'Bob','Jones');
GO

CREATE CLUSTERED INDEX IX_EmployeeDemo
ON dbo.EmployeeDemo(EmployeeID);
GO

SELECT *
FROM dbo.EmployeeDemo;



DROP TABLE IF EXISTS dbo.PhoneLog;
GO

CREATE TABLE dbo.PhoneLog
(
    ID INT IDENTITY(1,1),
    CallDurationSec INT,
    Notes CHAR(500)
);
GO

INSERT INTO dbo.PhoneLog
(
    CallDurationSec,
    Notes
)
SELECT
    ABS(CHECKSUM(NEWID())) % 1000,  -- random call duration between 0 and 999 seconds
    REPLICATE('X',500)  -- 500 characters to produce wide rows
FROM sys.objects a
CROSS JOIN sys.objects b;  -- sys.objects x sys.objects records
GO


SELECT *
FROM dbo.PhoneLog
WHERE CallDurationSec = 991;
-- should produce one or more rowse
-- Table Scan


CREATE NONCLUSTERED INDEX IX_CallDuration
ON dbo.PhoneLog(CallDurationSec);
GO

-- Repeat the SELECT statement
-- Index Seek


DBCC SHOW_STATISTICS
(
    'dbo.PhoneLog',
    'IX_CallDuration'
);

-- histogram


UPDATE STATISTICS dbo.PhoneLog;
EXEC sp_updatestats;

SELECT *
FROM dbo.PhoneLog
WHERE CallDurationSec = 991;

SELECT *
FROM dbo.PhoneLog WITH (INDEX(IX_CallDuration))
WHERE CallDurationSec = 991;
-- inspect the execution plan


-- view the wait stats for the query
SELECT
    wait_type,
    wait_time_ms
FROM sys.dm_os_wait_stats
ORDER BY wait_time_ms DESC;


BEGIN TRAN;

UPDATE dbo.EmployeeDemo
SET FirstName = 'Blocked'
WHERE EmployeeID = 1;
-- leave the transaction open and do not commit or rollback


-- In a new query window, execute the following SELECT statement while the transaction is still open
SELECT *
FROM dbo.EmployeeDemo
WHERE EmployeeID = 1;

-- view the execution plan and check the wait type for the SELECT statement
SELECT
    session_id,
    wait_type,
    wait_time
FROM sys.dm_exec_requests
WHERE session_id > 50;

