-- Prereq: SalesLT schema with Customer* and Address* tables

-- Run this query 3 times against the database
DECLARE @Counter INT 
SET @Counter=1
WHILE ( @Counter <= 10000)
BEGIN
   SELECT 
        RTRIM(a.Firstname) + ' ' + RTRIM(a.LastName)
       , b.AddressLine1
       , b.AddressLine2
       , RTRIM(b.City) + ', ' + RTRIM(b.StateProvince) + '  ' + RTRIM(b.PostalCode)
       , CountryRegion
       FROM SalesLT.Customer a
       INNER JOIN SalesLT.CustomerAddress c 
           ON a.CustomerID = c.CustomerID
       RIGHT OUTER JOIN SalesLT.Address b
           ON b.AddressID = c.AddressID
   ORDER BY a.LastName ASC
   SET @Counter  = @Counter  + 1
END

-- Check the database in the Azure portal
-- Open the Intelligent Performance section 
-- Open Query Performance Insight
-- click Reset
-- click the query or wait 5 minutes and click refresh
-- Reviewing the SQL text on the Query details page against the query you ran, you
-- will note that the Query details only includes the SELECT statement and not the
-- WHILE loop or other statement. This happens because Query Performance Insight 
-- relies on data from the Query Store, which only tracks Data Manipulation Language
-- (DML) statements such as SELECT, INSERT, UPDATE, DELETE, MERGE, and BULK INSERT
-- while ignoring Data Definition Language (DDL) statements.


