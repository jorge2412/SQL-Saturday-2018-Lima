USE WideWorldImporters;
GO

--Evaluarlo con una traza (Profiler)
SET STATISTICS IO ON
SELECT *
FROM Warehouse.StockGroups;
SET STATISTICS IO OFF


--Ver el table Scan (Tablas sin Indice)
SELECT *
FROM Warehouse.VehicleTemperatures;

--Key Lookup en  la busqueda
SELECT
StockGroupID,
StockGroupName,
ValidFrom,
ValidTo
FROM Warehouse.StockGroups
WHERE StockGroupName = 'Novelty Items';


--No tiene ningun Indice (da una adventencia)
SELECT *
FROM Warehouse.StockItems
--Agregamos el ordenamiento
ORDER BY StockItemName


--Creamos un Indice Nonclustered
CREATE NONCLUSTERED INDEX WarehouseNonClustered 
ON Warehouse.StockItems (StockItemName)  
INCLUDE (SupplierID); 

--Solo buscamos ordenado por StockItemName
SELECT SupplierID
FROM Warehouse.StockItems
ORDER BY StockItemName

/******************************Agregracion con un MASH*********************/
--Hash Match
SELECT
YEAR(InvoiceDate) AS InvoiceYear,
COUNT(InvoiceID) AS InvoiceCount
FROM Sales.Invoices
GROUP BY YEAR(InvoiceDate);

--Como mejorarlo con una vista indexada
ALTER VIEW Sales.vSalesByYear
WITH SCHEMABINDING
AS
SELECT
YEAR(InvoiceDate) AS InvoiceYear,
COUNT_BIG(*) AS InvoiceCount
FROM Sales.Invoices
GROUP BY YEAR(InvoiceDate);
GO

--Creando un indice para la vista
CREATE UNIQUE CLUSTERED INDEX idx_vSalesByYear
ON Sales.vSalesByYear
(InvoiceYear);
GO

--Ahora si ejecutas la consulta
SELECT
YEAR(InvoiceDate) AS InvoiceYear,
COUNT(InvoiceID) AS InvoiceCount
FROM Sales.Invoices
GROUP BY YEAR(InvoiceDate);


