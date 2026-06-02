-- depends on WideWorldImporters database
-- Optionally download with PowerShell
-- Check D: and E: disks for existence
-- mkdir D:\Data
-- mkdir E:\Log
-- mkdir C:\WWI
-- [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12   # niet nodig in w2019
-- Start-BitsTransfer -Source 'https://github.com/microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Full.bak' -Destination 'C:\WWI\WideWorldImporters-Full.bak'
-- RESTORE DATABASE WideWorldImporters FROM DISK = 'C:\WWI\WideWorldImporters-Full.bak' 
--'WWI_Primary' cannot be restored to 'D:\Data\WideWorldImporters.mdf'. Use WITH MOVE to identify a valid location for the file.
--'WWI_UserData' cannot be restored to 'D:\Data\WideWorldImporters_UserData.ndf'. Use WITH MOVE to identify a valid location for the file.
--'WWI_Log' cannot be restored to 'E:\Log\WideWorldImporters.ldf'. Use WITH MOVE to identify a valid location for the file.
--'WWI_InMemory_Data_1' cannot be restored to 'D:\Data\WideWorldImporters_InMemory_Data_1'. Use WITH MOVE to identify a valid location for the file.



USE WideWorldImporters

-- turn on live statistics
-- Alt-Q: include live statistics

-- inspect PurchaseOrders
SELECT * FROM Purchasing.PurchaseOrders


-- simple join
SELECT * FROM Purchasing.PurchaseOrders po
JOIN Purchasing.PurchaseOrderLines pl
ON po.PurchaseOrderID = pl.PurchaseOrderID


-- simple join
SELECT si.StockItemName, si.ColorID, si.Size, c.ColorName FROM Warehouse.StockItems si
JOIN Warehouse.Colors c
ON si.ColorID = c.ColorID


-- large table
SELECT * FROM warehouse.StockItemTransactions


-- very large table
SELECT * FROM warehouse.ColdRoomTemperatures_Archive


-- warning: heavy query on large table StockItemTransactions
SELECT * FROM Warehouse.StockItems si
JOIN Warehouse.StockItemTransactions st
ON si.StockItemID = st.StockItemID

