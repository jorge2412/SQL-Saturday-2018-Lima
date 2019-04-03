--Hash Match (Mejorarlo con un Nested Loop)
SELECT
si.StockItemName,
c.ColorName,
s.SupplierName
FROM Warehouse.StockItems si
INNER JOIN Warehouse.Colors c ON
c.ColorID = si.ColoriD
INNER JOIN Purchasing.Suppliers s ON
s.SupplierID = si.SupplierID;

--drop index IX_Purchasing_Suppliers_ExamBook762Ch4_SupplierID on Purchasing.Suppliers
--drop index IX_Warehouse_StockItems_ExamBook762Ch4_ColorID on Warehouse.StockItems
--Puedo crear un indice para eliminar el H)ash
CREATE NONCLUSTERED INDEX IX_Purchasing_Suppliers_ExamBook762Ch4_SupplierID
ON Purchasing.Suppliers
(
SupplierID ASC,
SupplierName
);
GO
CREATE NONCLUSTERED INDEX IX_Warehouse_StockItems_ExamBook762Ch4_ColorID
ON Warehouse.StockItems
(
ColorID ASC,
SupplierID ASC,
StockItemName ASC
);

DROP INDEX IX_Purchasing_Suppliers_ExamBook762Ch4_SupplierID ON Purchasing.Suppliers
DROP INDEX IX_Warehouse_StockItems_ExamBook762Ch4_ColorID ON Warehouse.StockItems

--Va a cambiarlos por los index seek
SELECT
si.StockItemName,
c.ColorName,
s.SupplierName
FROM Warehouse.StockItems si
INNER JOIN Warehouse.Colors c ON
c.ColorID = si.ColoriD
INNER JOIN Purchasing.Suppliers s ON
s.SupplierID = si.SupplierID;