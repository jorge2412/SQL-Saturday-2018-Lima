--Usar la base de datos creada en Memoria
USE MemDemo
 
-- Crear un procedimiento almacenado nativo
CREATE PROCEDURE dbo.InsertData
    WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
AS
BEGIN ATOMIC WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = 'us_english')
    DECLARE @Memid int = 1
    WHILE @Memid <= 500000
    BEGIN
        INSERT INTO dbo.MemoryTable VALUES (@Memid, GETDATE())
        SET @Memid += 1
    END
END;
GO
 
--Ejecutar el procedimiento almacenado
EXEC dbo.InsertData;
 
--Confirmar que ahora la tabla tiene 500000 registros.
SELECT COUNT(1) FROM dbo.MemoryTable;