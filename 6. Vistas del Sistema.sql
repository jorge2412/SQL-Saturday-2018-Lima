--Verificar las vistas creadas por el usuario
SELECT * FROM sys.views

--Verificar los nuevos campos para la tabla temporal(un nuevo feature en SQL Server 2016)
SELECT * FROM sys.tables

--Podemos buscar todos los objetos del sistema que sean vista
SELECT * FROM sys.objects
where type_desc='VIEW';

--Consultar informacion de tablas de esquemas
--comparar los resultados con sys.tables
SELECT * FROM INFORMATION_SCHEMA.TABLES

--VISTAS GESTIONADAS DINAMICAS (DMVs)
--Mostrar las conexiones
SELECT * FROM sys.dm_exec_connections

--
SELECT * FROM sys.dm_exec_sessions;

--
SELECT * FROM sys.dm_exec_requests

--Consultando las consultas mas costosas
SELECT TOP(20) qs.max_logical_reads,
               st.text
FROM sys.dm_exec_query_stats as qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as st
ORDER BY qs.max_logical_reads DESC