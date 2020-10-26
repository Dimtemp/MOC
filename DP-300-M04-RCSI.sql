USE master 
GO 
  
CREATE DATABASE TestDB 
GO 
  
USE TestDB 
GO 
  
CREATE TABLE TestTable 
( 
ID INT, 
Val CHAR(1) 
) 
  
INSERT INTO TestTable(ID, Val) 
VALUES (1,'A'),(2,'B'),(3, 'C') 

-- database isolation level is default – READ COMMITTED and the READ_COMMITTED_SNAPSHOT database option is OFF

USE TestDB 
GO 
  
BEGIN TRANSACTION 
  
  UPDATE TestTable 
  SET Val='X' 
  WHERE Val='A' 
  
  WAITFOR DELAY '00:00:07' 
  
COMMIT 

-- New Query window

USE TestDB 
GO 
  
SELECT * FROM TestTable

-- execute the first query and immediately after that, execute the second query
-- second query waits while the first transaction is completed and only after that, returns the modified results


ALTER DATABASE TestDB SET READ_COMMITTED_SNAPSHOT ON 

USE TestDB 
GO   
  
BEGIN TRANSACTION 
  
  UPDATE TestTable 
  SET Val='A' 
  WHERE Val='X' 
  
  WAITFOR DELAY '00:00:07' 
  
COMMIT 

- Run the second query window immediately after running the previous query.

USE TestDB 
GO 
  
SELECT * FROM TestTable 

-- second query does not wait for the first one to complete and immediately returns the result
