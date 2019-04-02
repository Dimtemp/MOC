-- Create a table with a primary key
USE Adventureworks;
GO

CREATE TABLE dbo.PhoneLog
( PhoneLogID int IDENTITY(1,1) PRIMARY KEY,
  LogRecorded datetime2 NOT NULL,
  PhoneNumberCalled nvarchar(100) NOT NULL,
  CallDurationMs int NOT NULL
);
GO

-- Insert some data into the table
SET NOCOUNT ON;
DECLARE @Counter int = 0;
WHILE @Counter < 10000 BEGIN
  INSERT dbo.PhoneLog (LogRecorded, PhoneNumberCalled, CallDurationMs)
    VALUES(SYSDATETIME(),'999-9999',CAST(RAND() * 1000 AS int));
  SET @Counter += 1;
END;
GO

-- Check fragmentation
SELECT * 
FROM sys.dm_db_index_physical_stats(DB_ID(),
                                    OBJECT_ID('dbo.PhoneLog'),
                                    NULL,
                                    NULL,
                                    'DETAILED');
GO

/*

database_id object_id   index_id    partition_number index_type_desc                                              alloc_unit_type_desc                                         index_depth index_level avg_fragmentation_in_percent fragment_count       avg_fragment_size_in_pages page_count           avg_page_space_used_in_percent record_count         ghost_record_count   version_ghost_record_count min_record_size_in_bytes max_record_size_in_bytes avg_record_size_in_bytes forwarded_record_count compressed_page_count hobt_id              columnstore_delete_buffer_state columnstore_delete_buffer_state_desc
----------- ----------- ----------- ---------------- ------------------------------------------------------------ ------------------------------------------------------------ ----------- ----------- ---------------------------- -------------------- -------------------------- -------------------- ------------------------------ -------------------- -------------------- -------------------------- ------------------------ ------------------------ ------------------------ ---------------------- --------------------- -------------------- ------------------------------- ------------------------------------------------------------
10          665769429   1           1                CLUSTERED INDEX                                              IN_ROW_DATA                                                  2           0           3.57142857142857             3                    18.6666666666667           56                   99.2551890289103               10000                0                    0                          43                       43                       43                       NULL                   0                     72057594069319680    0                               NOT VALID
10          665769429   1           1                CLUSTERED INDEX                                              IN_ROW_DATA                                                  2           1           0                            1                    1                          1                    8.96960711638251               56                   0                    0                          11                       11                       11                       NULL                   0                     72057594069319680    0                               NOT VALID
*/


GO


-- Modify the data in the table 
SET NOCOUNT ON;
DECLARE @Counter int = 0;
WHILE @Counter < 10000 BEGIN
  UPDATE dbo.PhoneLog SET PhoneNumberCalled = REPLICATE('9',CAST(RAND() * 100 AS int))
    WHERE PhoneLogID = @Counter % 10000;
  IF @Counter % 100 = 0 PRINT @Counter;
  SET @Counter += 1;
END;

-- Re-check fragmentation
SELECT * 
FROM sys.dm_db_index_physical_stats(DB_ID(),
                                    OBJECT_ID('dbo.PhoneLog'),
                                    NULL,
                                    NULL,
                                    'DETAILED');


/*
database_id object_id   index_id    partition_number index_type_desc                                              alloc_unit_type_desc                                         index_depth index_level avg_fragmentation_in_percent fragment_count       avg_fragment_size_in_pages page_count           avg_page_space_used_in_percent record_count         ghost_record_count   version_ghost_record_count min_record_size_in_bytes max_record_size_in_bytes avg_record_size_in_bytes forwarded_record_count compressed_page_count hobt_id              columnstore_delete_buffer_state columnstore_delete_buffer_state_desc
----------- ----------- ----------- ---------------- ------------------------------------------------------------ ------------------------------------------------------------ ----------- ----------- ---------------------------- -------------------- -------------------------- -------------------- ------------------------------ -------------------- -------------------- -------------------------- ------------------------ ------------------------ ------------------------ ---------------------- --------------------- -------------------- ------------------------------- ------------------------------------------------------------
10          665769429   1           1                CLUSTERED INDEX                                              IN_ROW_DATA                                                  2           0           89.8785425101215             224                  1.10267857142857           247                  64.3168519891278               10000                0                    0                          23                       225                      126.632                  NULL                   0                     72057594069319680    0                               NOT VALID
10          665769429   1           1                CLUSTERED INDEX                                              IN_ROW_DATA                                                  2           1           0                            1                    1                          1                    39.6466518408698               247                  0                    0                          11                       11                       11                       NULL                   0                     72057594069319680    0                               NOT VALID
*/


-- Rebuild the table and its indexes
ALTER INDEX ALL ON dbo.PhoneLog REBUILD;
GO

-- Check the fragmentation again
SELECT * 
FROM sys.dm_db_index_physical_stats(DB_ID(),
                                    OBJECT_ID('dbo.PhoneLog'),
                                    NULL,
                                    NULL,
                                    'DETAILED');
GO

/*
database_id object_id   index_id    partition_number index_type_desc                                              alloc_unit_type_desc                                         index_depth index_level avg_fragmentation_in_percent fragment_count       avg_fragment_size_in_pages page_count           avg_page_space_used_in_percent record_count         ghost_record_count   version_ghost_record_count min_record_size_in_bytes max_record_size_in_bytes avg_record_size_in_bytes forwarded_record_count compressed_page_count hobt_id              columnstore_delete_buffer_state columnstore_delete_buffer_state_desc
----------- ----------- ----------- ---------------- ------------------------------------------------------------ ------------------------------------------------------------ ----------- ----------- ---------------------------- -------------------- -------------------------- -------------------- ------------------------------ -------------------- -------------------- -------------------------- ------------------------ ------------------------ ------------------------ ---------------------- --------------------- -------------------- ------------------------------- ------------------------------------------------------------
10          665769429   1           1                CLUSTERED INDEX                                              IN_ROW_DATA                                                  2           0           0                            1                    161                        161                  98.6856313318508               10000                0                    0                          23                       225                      126.632                  NULL                   0                     72057594069385216    0                               NOT VALID
10          665769429   1           1                CLUSTERED INDEX                                              IN_ROW_DATA                                                  2           1           0                            1                    1                          1                    25.8339510748703               161                  0                    0                          11                       11                       11                       NULL                   0                     72057594069385216    0                               NOT VALID

(2 row(s) affected)
*/