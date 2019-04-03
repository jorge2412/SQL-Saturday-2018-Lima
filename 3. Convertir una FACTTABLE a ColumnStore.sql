--Convertir una FACT TABLE  de RowStore a ColumnStore
--1. Crear una pequeña tabla con indice
CREATE TABLE MyFactTable (  
    ProductKey [int] NOT NULL,  
    OrderDateKey [int] NOT NULL,  
     DueDateKey [int] NOT NULL,  
     ShipDateKey [int] NOT NULL )  
)  
WITH (  
    CLUSTERED INDEX ( ProductKey )  
);  

--Add a non-clustered index.  
--Agregar un indice nonclustered
CREATE INDEX my_index ON MyFactTable ( ProductKey, OrderDateKey );  

--2. Borrar todos los indices nonclustered
DROP INDEX my_index ON MyFactTable; 

--3. Borrar los indices CLUSTERED
SELECT i.name   
FROM sys.indexes i   
JOIN sys.tables t  
ON ( i.type_desc = 'CLUSTERED' ) WHERE t.name = 'MyFactTable';  

--Drop the clustered rowstore index.  
DROP INDEX ClusteredIndex_d473567f7ea04d7aafcac5364c241e09 ON MyDimTable;

--4. Convertir a ColumnStore la tabla
CREATE CLUSTERED COLUMNSTORE INDEX MyCCI ON MyFactTable; 

