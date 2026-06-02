-- prereq: running SQL Server

-- create a login for testing
CREATE LOGIN ReportUser WITH PASSWORD = 'YourStrongPasswordHere';

-- Create a Resource Pool
USE master;
GO

CREATE RESOURCE POOL ReportingPool
WITH
(
    MAX_CPU_PERCENT = 20
);
GO

-- Create a Workload Group
CREATE WORKLOAD GROUP ReportingGroup
USING ReportingPool;
GO

-- create a classifier 
CREATE OR ALTER FUNCTION dbo.rgClassifier()
RETURNS sysname
WITH SCHEMABINDING
AS
BEGIN
    DECLARE @GroupName sysname = 'default';

    IF SUSER_NAME() = 'ReportUser'
        SET @GroupName = 'ReportingGroup';

    RETURN @GroupName;
END;
GO


-- activate resource governor
ALTER RESOURCE GOVERNOR
WITH (CLASSIFIER_FUNCTION = dbo.rgClassifier);
GO

ALTER RESOURCE GOVERNOR RECONFIGURE;
GO

-- check configuration
SELECT
    pool_id,
    name,
    max_cpu_percent
FROM sys.resource_governor_resource_pools;

-- show the effect

-- ssms window 1 (admin)
SELECT
    group_id,
    name
FROM sys.dm_resource_governor_workload_groups;

-- ssms window 2 (ReportUser)
WITH Numbers AS
(
    SELECT TOP (5000000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a
    CROSS JOIN sys.objects b
    CROSS JOIN sys.objects c
)
SELECT SUM(n)
FROM Numbers;
-- session enters the workload group and is limited to 20% CPU usage.

-- check the effect of the workload group
SELECT
    g.name AS WorkloadGroup,
    p.name AS ResourcePool,
    g.total_request_count,
    g.total_cpu_usage_ms
FROM sys.dm_resource_governor_workload_groups g
JOIN sys.resource_governor_resource_pools p
    ON g.pool_id = p.pool_id;
Opruimen
ALTER RESOURCE GOVERNOR
WITH (CLASSIFIER_FUNCTION = NULL);
GO

-- drop the created objects
ALTER RESOURCE GOVERNOR RECONFIGURE;
GO

DROP FUNCTION dbo.rgClassifier;
DROP WORKLOAD GROUP ReportingGroup;
DROP RESOURCE POOL ReportingPool;
GO
