--Crear una base de datos MemDemo
CREATE DATABASE MemDemo

--Usamos esa base de datos
USE MemDemo
GO

--Crear la tabla en Memoria
CREATE TABLE dbo.MemoryTable
(id INTEGER NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT = 1000000),
 date_value DATETIME NULL)
WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA);
 
 
--Crear una tabla en disco
CREATE TABLE dbo.DiskTable
(id INTEGER NOT NULL PRIMARY KEY NONCLUSTERED,
 date_value DATETIME NULL);
 
 
--Insertaremos 500000 registros en la tabla en disco
BEGIN TRAN
    DECLARE @Diskid int = 1
    WHILE @Diskid <= 500000
    BEGIN
        INSERT INTO dbo.DiskTable VALUES (@Diskid, GETDATE())
        SET @Diskid += 1
    END
COMMIT;
 
--Verificamos esos 500000 registros
SELECT COUNT(*) FROM dbo.DiskTable;
 
--Ahora insertamos en memoria, el tiempo de inserccion deberia ser menor que en disco
BEGIN TRAN
    DECLARE @Memid int = 1
    WHILE @Memid <= 500000
    BEGIN
        INSERT INTO dbo.MemoryTable VALUES (@Memid, GETDATE())
        SET @Memid += 1
    END
COMMIT;
 
--Confirmamos la cantidad de registros de ambos
SELECT COUNT(*) FROM dbo.MemoryTable;
 
--Nota que tan larfo es ejecutar un DELETE en Disxo
DELETE FROM DiskTable;
 
--Esto deberia ser significativamenete menor en memoria
DELETE FROM MemoryTable;
 
--Ver estadisticas de tablas optimizadas para memoria
SELECT o.Name, m.*
FROM
sys.dm_db_xtp_table_memory_stats m
JOIN sys.sysobjects o
ON m.object_id = o.id