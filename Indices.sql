--Utilizamos la base de datos Tempdb
USE tempdb;
GO
  
--Crear una tabla especificando un inde clustered
CREATE TABLE dbo.PhoneLog
( PhoneLogID int IDENTITY(1,1) PRIMARY KEY,
  LogRecorded datetime2 NOT NULL,
  PhoneNumberCalled nvarchar(100) NOT NULL,
  CallDurationMs int NOT NULL
);
GO
 
--Se crea automaticamente el indice y la restriccion
SELECT * FROM sys.indexes WHERE OBJECT_NAME(object_id) = N'PhoneLog';
GO
SELECT * FROM sys.key_constraints WHERE OBJECT_NAME(parent_object_id) = N'PhoneLog';
GO
 
 
--Insertar algo de data en la tabla
SET NOCOUNT ON;
 
INSERT dbo.PhoneLog (LogRecorded, PhoneNumberCalled, CallDurationMs)
    VALUES(SYSDATETIME(),'999-9999',CAST(RAND() * 1000 AS int))
GO 100000 --insertar 100000 veces


--Vemos los datos de la tabla 
select * from dbo.PhoneLog

--Veremos el nivel de fragmentacion que tuviera la tabla
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(),OBJECT_ID('dbo.PhoneLog'),NULL,NULL,'DETAILED');
GO

--Verificar avg_fragmentation_in_percent and avg_page_space_used_in_percent
 

--Modificar la data en la tabla, esto incrementara la data y causara fragmentacion
SET NOCOUNT ON;
 
DECLARE @Counter int = 0;
 
WHILE @Counter < 100000 BEGIN
  UPDATE dbo.PhoneLog SET PhoneNumberCalled = REPLICATE('9',CAST(RAND() * 100 AS int))
    WHERE PhoneLogID = @Counter % 100000;
  IF @Counter % 100 = 0 PRINT @Counter;
  SET @Counter += 1;
END;
GO
 
 
--Verificamos el nivel de fragmentacion via sys.dm_db_index_physical_stats
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(),OBJECT_ID('dbo.PhoneLog'),NULL,NULL,'DETAILED');
GO
 
--Verificar avg_fragmentation_in_percent and avg_page_space_used_in_percent
 
--Reconstruir la tabla y el indice
ALTER INDEX ALL ON dbo.PhoneLog REBUILD;
GO
 
 
--Verifico el nivel de fragmentacion via sys.dm_db_index_physical_stats
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(),OBJECT_ID('dbo.PhoneLog'),NULL,NULL,'DETAILED');
GO
 
 
--Verificar avg_fragmentation_in_percent and avg_page_space_used_in_percent
 
 
--Correr esta consulta viendo el plan de ejecucion (Adventureworks)
SELECT [PhoneLogID]
      ,[LogRecorded]
      ,[PhoneNumberCalled]
      ,[CallDurationMs]
      ,p.Name
  FROM [tempdb].[dbo].[PhoneLog] pl join [AdventureWorks].[Production].Product p
  ON pl.CallDurationMs = p.ProductID
GO
 
-- Step 14: Create a covering index, point out the columns included
-- Crear un indicem con columnas incluidas
CREATE NONCLUSTERED INDEX NCIX_CallDurationMS
ON [dbo].[PhoneLog] ([CallDurationMs])
INCLUDE ([PhoneLogID],[LogRecorded],[PhoneNumberCalled])
GO
 
--Ejecuta el siguiente plan de ejecucion y se vera que no usa el indice
SELECT [PhoneLogID]
      ,[LogRecorded]
      ,[PhoneNumberCalled]
      ,[CallDurationMs]
      ,p.Name
  FROM [tempdb].[dbo].[PhoneLog] pl join [AdventureWorks].[Production].Product p
  ON pl.CallDurationMs = p.ProductID
GO
 
--Borrar la tabla
DROP TABLE dbo.PhoneLog;
GO