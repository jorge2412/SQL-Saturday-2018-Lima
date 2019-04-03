USE AdventureWorks2016;  
GO  

--Activamos la opcion para soportar vistas indexadas
SET NUMERIC_ROUNDABORT OFF;  
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT,  
    QUOTED_IDENTIFIER, ANSI_NULLS ON;  
GO  

--Siempre crear una Vista con Schemabinding
IF OBJECT_ID ('Sales.vOrders', 'view') IS NOT NULL  
DROP VIEW Sales.vOrders ;  
GO  
CREATE VIEW Sales.vOrders  
WITH SCHEMABINDING  
AS  
    SELECT SUM(UnitPrice*OrderQty*(1.00-UnitPriceDiscount)) AS Revenue,  
        OrderDate, ProductID, COUNT_BIG(*) AS COUNT  
    FROM Sales.SalesOrderDetail AS od, Sales.SalesOrderHeader AS o  
    WHERE od.SalesOrderID = o.SalesOrderID  
    GROUP BY OrderDate, ProductID;  
GO  
  
--Crear un indice en la vista
CREATE UNIQUE CLUSTERED INDEX IDX_V1   
    ON Sales.vOrders (OrderDate, ProductID);  
GO  


--Esta consulta puede usar el indice de la vista, si incluso la vista
--no esta especificada en la clausula FROM
SELECT SUM(UnitPrice*OrderQty*(1.00-UnitPriceDiscount)) AS Rev,   
    OrderDate, ProductID  
FROM Sales.SalesOrderDetail AS od  
    JOIN Sales.SalesOrderHeader AS o ON od.SalesOrderID=o.SalesOrderID  
        AND ProductID BETWEEN 700 and 800  
        AND OrderDate >= CONVERT(datetime,'05/01/2002',101)  
GROUP BY OrderDate, ProductID  
ORDER BY Rev DESC;  
GO  

--Esta consulta puede usar la vista indexada arriba
SELECT  OrderDate, SUM(UnitPrice*OrderQty*(1.00-UnitPriceDiscount)) AS Rev  
FROM Sales.SalesOrderDetail AS od  
    JOIN Sales.SalesOrderHeader AS o ON od.SalesOrderID=o.SalesOrderID  
        AND DATEPART(mm,OrderDate)= 3  
        AND DATEPART(yy,OrderDate) = 2002  
GROUP BY OrderDate  
ORDER BY OrderDate ASC;  
GO  