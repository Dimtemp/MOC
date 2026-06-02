-- Step 1:Create a table with a check constraint

USE tempdb;
GO

CREATE TABLE dbo.TSample 
( TSampleID int NOT NULL,
  TSampleName varchar(10) NOT NULL,
  Salary decimal(18,2) NOT NULL
  CONSTRAINT SalaryCap CHECK (Salary < 100000)
);

-- Step 2:Insert valid data
--        (2 rows will be inserted)

INSERT INTO dbo.TSample VALUES (1,'Joe Brown',65000);
INSERT INTO dbo.TSample VALUES (2,'Mary Smith',75000);
GO

-- Step 3: Try to insert data that violates the constraint.
--         (Will fail with a constraint violation)

INSERT INTO dbo.TSample VALUES (3,'Pat Jones',105000);
GO

-- Step 4: Disable the constraint and try again. Point out that the insert will work now.
--         (1 row will be inserted)

ALTER TABLE dbo.TSample NOCHECK CONSTRAINT SalaryCap;
GO

INSERT INTO dbo.TSample VALUES (3,'Pat Jones',105000);
GO

-- Step 5: Re-enable the constraint. Notice that it works even though
--         existing data does not meet the constraint. 
--         Note that NOCHECK is the default. Then check the sys.check_constraints
--         view and note the check constraint status in the is_not_trusted column.

ALTER TABLE dbo.TSample CHECK CONSTRAINT SalaryCap;
GO
SELECT name, is_not_trusted FROM sys.check_constraints;
GO

-- Step 6: Disable the constraint and and enable again but this time use WITH CHECK. 
--         Note that it is not working, since the existing data is checked now.

ALTER TABLE dbo.TSample NOCHECK CONSTRAINT SalaryCap;
GO

ALTER TABLE dbo.TSample 
  WITH CHECK 
    CHECK CONSTRAINT SalaryCap;
GO

-- Step 7: DELETE the row and try to enable again. Note that it is working now.

DELETE FROM dbo.TSample WHERE TSampleID = 3;
GO

ALTER TABLE dbo.TSample WITH CHECK CHECK CONSTRAINT SalaryCap;
GO
