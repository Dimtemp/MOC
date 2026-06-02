/*
	prereq: using SSMS restore WideWorldImporters-Standard.bacpac from:
	https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0
*/

SELECT @@VERSION
/*
	Check SQL version
	verify at https://sqlserverbuilds.blogspot.com/
	15: 2019
	14: 2017
	13: 2016
	12: 2014
	11: 2012
*/



--	Enable query store and clear anything that may be in there

ALTER DATABASE [WideWorldImporters] SET QUERY_STORE = ON;
GO
ALTER DATABASE [WideWorldImporters] SET QUERY_STORE CLEAR;
GO


/*
	Scenario
	A stored procedure will be compiled with param 1050, which will result in a index seek lookup
	In another situation, the stored procedure will be compiled with param 401, which will result in a clustered index scan


	Create stored procedures for testing

	Note: CREATE OR ALTER was introduced in SQL 2016 SP1
*/
USE [WideWorldImporters]
GO

CREATE OR ALTER PROCEDURE [Sales].[usp_CustomerTransactionInfo]
	@CustomerID INT
AS	
	SELECT [CustomerID], SUM([AmountExcludingTax])
	FROM [Sales].[CustomerTransactions]
	WHERE [CustomerID] = @CustomerID
	GROUP BY [CustomerID];
GO

CREATE OR ALTER PROCEDURE [Application].[usp_GetPersonInfo] (@PersonID INT)
AS
	SELECT 
		[p].[FullName], 
		[p].[EmailAddress], 
		[c].[FormalName]
	FROM [Application].[People] [p]
	LEFT OUTER JOIN [Application].[Countries] [c] 
		ON [p].[PersonID] = [c].[LastEditedBy]
	WHERE [p].[PersonID] = @PersonID;
GO

--  Ensure the appropriate plan is in cache for demo
USE [WideWorldImporters];
GO
EXEC [Sales].[usp_CustomerTransactionInfo] 1050;
GO


/*
	Start workload using these two files
	(external to SSMS):
	
	0_Prep__create_2_clients_usp_CustomerTransactionInfo.cmd
	0_Prep__create_2_clients_usp_GetPersonInfo.cmd
	
	Let workload run for 2-3 minutes
*/


USE [WideWorldImporters];
SET NOCOUNT ON;     -- Stops the message that shows the count of the number of rows affected ... from being returned as part of the result set.
SET ARITHABORT ON;  -- Ends a query when an overflow or divide-by-zero error occurs during query execution
GO


-- 	0_Prep__create_2_clients_usp_GetPersonInfo.cmd


DECLARE @PersonID INT;

SELECT @PersonID = (
	SELECT TOP 1 [PersonID]
	FROM [Application].[People]
	ORDER BY NEWID());

-- JOIN from [Application].[People] and [Application].[Countries]
EXEC [Application].[usp_GetPersonInfo] @PersonID;

GO 100


-- 	0_Prep__create_2_clients_usp_CustomerTransactionInfo.cmd

DECLARE @CustomerID INT;

SELECT @CustomerID = (
	SELECT TOP 1 [CustomerID] 
	FROM [Sales].[CustomerTransactions]
	ORDER BY NEWID());

EXEC [Sales].[usp_CustomerTransactionInfo] @CustomerID;
-- FROM [Sales].[CustomerTransactions] GROUP BY CustomerID

GO 10




/*
	Add some data to the table
	to simulate data being added during a
	normal work day

	Many rows changed, stats invalidated, plans that use those stats need to be recompiled

	Note: this query will only work on fresh database restore.

*/

USE [WideWorldImporters];
GO

INSERT INTO [Sales].[CustomerTransactions](
	[CustomerTransactionID], 
	[CustomerID],
	[TransactionTypeID],
	[InvoiceID],
	[PaymentMethodID],
	[TransactionDate], 
	[AmountExcludingTax],
	[TaxAmount],
	[TransactionAmount],
	[OutstandingBalance],
	[FinalizationDate],
	[LastEditedBy],
	[LastEditedWhen]
	)
SELECT 
	[CustomerTransactionID] + 385500, [CustomerID], 
	[TransactionTypeID], 1, [PaymentMethodID], 
	[TransactionDate], ([CustomerID] + 5) * 2, 
	(([CustomerID] + 5) * 2) * .05, 
	(([CustomerID] + 5) * 2) + ((([CustomerID] + 5) * 2) * .05), 
	[OutstandingBalance],[FinalizationDate],[LastEditedBy],
	[LastEditedWhen]
FROM [Sales].[CustomerTransactions] 
WHERE [AmountExcludingTax] = 0;


-- force the "bad" plan for the demo
DBCC FREEPROCCACHE;  -- very bad statement, Removes all elements from the plan cache
GO
-- Clearing the procedure (plan) cache causes all plans to be evicted, and incoming query executions will compile a new plan, instead of reusing any previously cached plan.
-- This can cause a sudden, temporary decrease in query performance as the number of new compilations increases.

USE [WideWorldImporters];
GO
EXEC [Sales].[usp_CustomerTransactionInfo] 401;  -- known to generate a bad plan: clustered index scan
GO


-- Query to confirm the plan in cache currently is the clustered index scan
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
-- statements can read rows that have been modified by other transactions but not yet committed.
GO
SELECT 
	[qs].execution_count, 
	[s].[text], 
	[qs].[query_hash], 
	[qs].[query_plan_hash], 
	[cp].[size_in_bytes]/1024 AS [PlanSizeKB], 
	[qp].[query_plan], 
	[qs].[plan_handle]
FROM sys.dm_exec_query_stats AS [qs]
CROSS APPLY sys.dm_exec_query_plan ([qs].[plan_handle]) AS [qp]
CROSS APPLY sys.dm_exec_sql_text([qs].[plan_handle]) AS [s]
INNER JOIN sys.dm_exec_cached_plans AS [cp] 
	ON [qs].[plan_handle] = [cp].[plan_handle]
WHERE [s].[text] LIKE '%CustomerTransactionInfo%';
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- reset to default
GO
-- Click the query plan XML and confirm it performs a clustered index scan



-- 1_QueryStoreInAction.sql

/*
	What do we see in the Query StoreUI?
	new: Queries with forced plans (2016 SP1)
	new: Queries with high variation
	new: Query Wait Statistics

	Regressed Queries
		Configure: time scale
		Grid: object name: usp_CustomerTransaction, notice num plans: 2
		Select both, click compare
		Notice NEQ icons
*/



/*
	What do we get from the system views?
	Note that most info is also available in the GUI
*/
USE [WideWorldImporters];
GO

-- next three from plan store
SELECT * FROM [sys].[query_store_query];
GO
-- notice hash

SELECT * FROM [sys].[query_store_query_text];
GO

SELECT * FROM [sys].[query_store_plan];
GO
-- one query can have more than one plan


-- this is from the runtime stats store
SELECT * FROM [sys].[query_store_runtime_stats];
GO
-- notice duration and io columns


-- Query compile and optimization information
SELECT 
	[qst].[query_text_id], 
	[qsq].[query_id], 
	[qsq].[object_id], 
	[qsq].[context_settings_id], 
	[qst].[query_sql_text], 
	[qsq].[initial_compile_start_time], 
	[qsq].[last_compile_start_time],
	[qsq].[last_execution_time], 
	[qsq].[avg_compile_duration], 
	[qsq].[count_compiles], 
	[qsq].[avg_optimize_cpu_time], 
	[qsq].[avg_optimize_duration]
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id];
GO


/*
	Query plan and execution information
	replace [qsp].[query_id] = 3
*/
SELECT
	[qsq].[query_id], 
	[qsp].[plan_id],
	[qsq].[object_id],
	[qsq].[initial_compile_start_time],
	[qsq].[last_compile_start_time], 
	[rs].[first_execution_time],
	[rs].[last_execution_time],
	[rs].[avg_duration],
	[rs].[avg_logical_io_reads],
	TRY_CONVERT(XML, [qsp].[query_plan]),
	[qsp].[query_plan],
	[rs].[count_executions],
	[qst].[query_sql_text]
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
JOIN [sys].[query_store_runtime_stats] [rs] 
	ON [qsp].[plan_id] = [rs].[plan_id]
WHERE [qsp].[query_id] = 3
GO
-- Confirm that the query has at least two plans, or just proceed to next statement



-- Queries executed in the last 8 hours with multiple plans
SELECT
	[qsq].[query_id], 
	COUNT([qsp].[plan_id]) AS [PlanCount],
	[qsq].[object_id], 
	MAX(DATEADD(MINUTE, -(DATEDIFF(MINUTE, GETDATE(), GETUTCDATE())), 
		[qsp].[last_execution_time])) AS [LocalLastExecutionTime],
	MAX([qst].query_sql_text) AS [Query_Text]
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
WHERE [qsp].[last_execution_time] > DATEADD(HOUR, -8, GETUTCDATE())
GROUP BY [qsq].[query_id], [qsq].[object_id]
HAVING COUNT([qsp].[plan_id]) > 1;
GO

-- Confirm the plan that's being used now
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SELECT 
	[qs].[execution_count], 
	[qs].[last_execution_time],
	[s].[text], 
	[qp].[query_plan], 
	[qs].[plan_handle]
FROM [sys].[dm_exec_query_stats] AS [qs]
CROSS APPLY [sys].[dm_exec_query_plan] ([qs].[plan_handle]) AS [qp]
CROSS APPLY [sys].[dm_exec_sql_text]([qs].[plan_handle]) AS [s]
JOIN [sys].[dm_exec_cached_plans] AS [cp] 
	ON [qs].[plan_handle] = [cp].[plan_handle]
WHERE [s].[text] LIKE '%CustomerTransactionInfo%';
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO


-- Check the distribution of data
SELECT [CustomerID], COUNT(*) AS Count
FROM [Sales].[CustomerTransactions]
GROUP BY [CustomerID]
ORDER BY [CustomerID] ASC;
GO

-- Ref: 1050 index seek lookup
--       401 clustered index scan

