DROP DATABASE StatisticsDB
--Crearemos una base de datos ficticia
CREATE DATABASE StatisticsDB;
GO
--Alteramos la base de datos para que las estadisticas no se creen automaticamente
ALTER DATABASE StatisticsDB
SET AUTO_CREATE_STATISTICS OFF;

--Alteramos la base de datos para que no actualice las estadisticas
ALTER DATABASE StatisticsDB
SET AUTO_UPDATE_STATISTICS OFF;

--Alternamos la base de datos para que las estadisticas asincronas esten deshabilitadas
ALTER DATABASE StatisticsDB
SET AUTO_UPDATE_STATISTICS_ASYNC OFF;
GO

--Utilizamos la base de datos creada
USE StatisticsDB;
GO

--Creamos el Schema Ejemplo
CREATE SCHEMA Ejemplo;
GO
CREATE TABLE Ejemplo.Ordenes (
OrderLineID int NOT NULL,
OrderID int NOT NULL,
StockItemID int NOT NULL,
Description nvarchar(100) NOT NULL,
PackageTypeID int NOT NULL,
Quantity int NOT NULL,
UnitPrice decimal(18, 2) NULL,
TaxRate decimal(18, 3) NOT NULL,
PickedQuantity int NOT NULL,
PickingCompletedWhen datetime2(7) NULL,
LastEditedBy int NOT NULL,
LastEditedWhen datetime2(7) NOT NULL);
GO

--Insertamos algunos registros de OrderLines
INSERT INTO Ejemplo.Ordenes
SELECT *
FROM WideWorldImporters.Sales.OrderLines;
GO

--Creamos un indice por la llave primaria
CREATE INDEX ix_OrderLines_StockItemID
ON Ejemplo.Ordenes (StockItemID);
GO

--Mostramos la estadistica
DBCC SHOW_STATISTICS ('Ejemplo.Ordenes',ix_OrderLines_StockItemID );
GO

--Veamos el plan de ejecucion Actual (TOMA TOTALMENTE EL INDICE) --1048
SELECT StockItemID
FROM Ejemplo.Ordenes
WHERE StockItemID = 1;

/*************************************Actualizaremos algunos registros***********************/
--Ahora actualizaremos el algunos registros
UPDATE Ejemplo.Ordenes
SET StockItemID = 1
WHERE OrderLineID < 45000;

--Ahora veremos las estadisticas
DBCC SHOW_STATISTICS ('Ejemplo.Ordenes',
ix_OrderLines_StockItemID );

--Ejecutaremos la misma consulta para ver el plan de ejecucion
SELECT StockItemID
FROM Ejemplo.Ordenes
WHERE StockItemID = 1;