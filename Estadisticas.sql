-- Demonstration 3
 
--Usando AdventureWorks
USE AdventureWorks;
GO
 
--Que nos muestre las estadisticas de una tabla
DBCC SHOW_STATISTICS ("Sales.SalesOrderDetail", PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID);
GO
 
-- End Step 1
 
-- Step 2: Check the freshness of the statistics, CTRL-M to switch on Execution Plan


SELECT soh.AccountNumber
        , soh.CustomerID
        , sod.* 
FROM Sales.SalesOrderDetail sod 
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID;
 
-- Click on the Execution Plan tab, scroll right and point at Clustered Index Scan, show that 
-- Actual Number of Rows (121317) is equal to Estimated Number of Rows (121317)
 
-- End Step 2