-- SQL script from DP-300 M02 lab
-- prereq: SalesLT schema with tables: Product, SalesOrderDetail, SalesOrderHeader 

CREATE USER [DP300User1] WITH PASSWORD = 'Azur3Pa$$';
GO

CREATE USER [DP300User2] WITH PASSWORD = 'Azur3Pa$$';
GO

CREATE ROLE [SalesReader];
GO

ALTER ROLE [SalesReader] ADD MEMBER [DP300User1];
GO

ALTER ROLE [SalesReader] ADD MEMBER [DP300User2];
GO

CREATE OR ALTER PROCEDURE SalesLT.DemoProc
AS
SELECT P.Name, Sum(SOD.LineTotal) as TotalSales ,SOH.OrderDate
FROM SalesLT.Product P
INNER JOIN SalesLT.SalesOrderDetail SOD on SOD.ProductID = P.ProductID
INNER JOIN SalesLT.SalesOrderHeader SOH on SOH.SalesOrderID = SOD.SalesOrderID
GROUP BY P.Name, SOH.OrderDate
ORDER BY TotalSales DESC
GO

EXECUTE AS USER = 'DP300User1'
EXECUTE SalesLT.DemoProc
REVERT;
GRANT EXECUTE ON SCHEMA::SalesLT TO [SalesReader];
GO

EXECUTE AS USER = 'DP300User1'
EXECUTE SalesLT.DemoProc
