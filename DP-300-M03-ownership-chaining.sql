-- prereq: using SSMS restore database from:
-- https://github.com/MicrosoftLearning/DP-300T00-Administering-Relational-Databases-on-Azure/blob/master/Allfiles/Labs/Secure%20Environment/AdventureWorks.bacpac
-- create a user in the database
CREATE USER [User1] WITH PASSWORD = 'Azur3Pa$$'
GO

-- create a custom role and add the user to it
CREATE ROLE [SalesReader]
GO
ALTER ROLE [SalesReader] ADD MEMBER [User1]
GO

-- grant permissions to the role
GRANT SELECT, EXECUTE ON SCHEMA::Sales TO [SalesReader]
GO

-- create a new stored procedure in the Sales schema, accesses a table in the Product schema
CREATE OR ALTER PROCEDURE Sales.DemoProc
AS
SELECT P.Name, Sum(SOD.LineTotal) as TotalSales, SOH.OrderDate 
FROM Production.Product P
INNER JOIN Sales.SalesOrderDetail SOD on SOD.ProductID = P.ProductID
INNER JOIN Sales.SalesOrderHeader SOH on SOH.SalesOrderID = SOD.SalesOrderID
GROUP BY P.Name, SOH.OrderDate
ORDER BY TotalSales DESC
GO

-- test out the security you just created
EXECUTE AS USER = 'User1'

SELECT P.Name, Sum(SOD.LineTotal) as TotalSales, SOH.OrderDate 
FROM Production.Product P
INNER JOIN Sales.SalesOrderDetail SOD on SOD.ProductID = P.ProductID
INNER JOIN Sales.SalesOrderHeader SOH on SOH.SalesOrderID = SOD.SalesOrderID
GROUP BY P.Name, SOH.OrderDate
ORDER BY TotalSales DESC

-- query will fail: SELECT permission was denied on the Production.Product table
-- role has SELECT permission in the Sales schema, but not in the Production schema

-- ownership chaining: provide data access to users who do not have direct permissions to access database objects. 
-- For all objects that have the same owner, the database engine only checks the EXECUTE permission on the procedure and not the underlying objects
-- execute the stored procedure in that same context, the query will complete
EXECUTE AS USER = 'User1'

EXECUTE Sales.DemoProc
