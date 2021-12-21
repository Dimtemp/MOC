-- depends on WWI database
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

