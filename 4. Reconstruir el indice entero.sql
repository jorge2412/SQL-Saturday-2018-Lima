--Convertir un columnstore a rowstore
CREATE CLUSTERED INDEX ci_MyTable   
ON MyFactTable  
WITH ( DROP EXISTING = ON );

----Convertir un columnstore a heap
DROP INDEX MyCCI   
ON MyFactTable;


--Defragmentar o reconstruir el indice columnstore
--1. Verificar e nombre del ColumnStore
SELECT i.object_id, i.name, t.object_id, t.name   
FROM sys.indexes i   
JOIN sys.tables t  
ON (i.type_desc = 'CLUSTERED COLUMNSTORE')  
WHERE t.name = 'RowstoreDimTable';  


--2. Reconstruir el indice entero
CREATE CLUSTERED COLUMNSTORE INDEX my_CCI   
ON MyFactTable  
WITH ( DROP_EXISTING = ON ); --Si existe lo borra

--3. Reconstruir el indice entero alterandolo
ALTER INDEX my_CCI  
ON MyFactTable  
REBUILD PARTITION = ALL  
WITH ( DROP_EXISTING = ON );