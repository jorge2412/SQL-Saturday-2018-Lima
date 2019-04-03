--Crear la tabla para usar en el ejemplo
CREATE TABLE SimpleTable (  
    ProductKey [int] NOT NULL,   
    OrderDateKey [int] NOT NULL,   
    DueDateKey [int] NOT NULL,   
    ShipDateKey [int] NOT NULL);  
GO  

--Crear dos indices nonclustered para usa con este ejemplo
CREATE INDEX nc1_simple ON SimpleTable (OrderDateKey);  
CREATE INDEX nc2_simple ON SimpleTable (DueDateKey);   
GO  
   
--En SQL Server 2012 y 2014 se necesita borrar el indice nonclustered
-- Luego puedo crear el indice columnstore
DROP INDEX SimpleTable.nc1_simple;  
DROP INDEX SimpleTable.nc2_simple;  

--COnvertir la tabla de fila a index a traves de columnas
CREATE CLUSTERED COLUMNSTORE INDEX cci_simple ON SimpleTable;   
GO  