-- prereq: AdventureWorksLT database (sample DB from Azure SQL DB)
-- Open the sample DB and enable dynamic data masking for the LastName column, the perform the following SQL script.

SELECT TOP 10 FirstName, MiddleName, LastName
FROM SalesLT.Customer;

-- Create a new SQL user and give them a password
CREATE USER Bob WITH PASSWORD = 'c0mpl3xPassword!';

-- Until you run the following two lines, Bob has no access to read or write data
ALTER ROLE db_datareader ADD MEMBER Bob;
ALTER ROLE db_datawriter ADD MEMBER Bob;

-- Execute as our new, low-privilege user, Bob
EXECUTE AS USER = 'Bob';
SELECT TOP 10 FirstName, MiddleName, LastName
FROM SalesLT.Customer;
REVERT;

GRANT UNMASK TO Bob;  
EXECUTE AS USER = 'Bob';
SELECT TOP 10 FirstName, MiddleName, LastName
FROM SalesLT.Customer;
REVERT;  


-- Remove unmasking privilege
REVOKE UNMASK TO Bob;  

-- Execute as Bob
EXECUTE AS USER = 'Bob';
SELECT TOP 10 FirstName, MiddleName, LastName
FROM SalesLT.Customer;
REVERT;  

