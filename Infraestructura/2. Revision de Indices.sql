

--Revisar el uso de indexes actuales
SELECT
OBJECT_NAME(ixu.object_id, DB_ID('WideWorldImporters')) AS [object_name] ,
ix.[name] AS index_name ,
ixu.user_seeks + ixu.user_scans + ixu.user_lookups AS user_reads,
ixu.user_updates AS user_writes
FROM sys.dm_db_index_usage_stats ixu
INNER JOIN WideWorldImporters.sys.indexes ix ON
ixu.[object_id] = ix.[object_id] AND
ixu.index_id = ix.index_id
WHERE ixu.database_id = DB_ID('WideWorldImporters')
ORDER BY user_reads DESC;

--Revisar el uso de indices que no se usan
USE WideWorldImporters;
GO
SELECT
OBJECT_NAME(ix.object_id) AS ObjectName ,
ix.name
FROM sys.indexes AS ix
INNER JOIN sys.objects AS o ON
ix.object_id = o.object_id
WHERE ix.index_id NOT IN (
SELECT ixu.index_id
FROM sys.dm_db_index_usage_stats AS ixu
WHERE
ixu.object_id = ix.object_id AND
ixu.index_id = ix.index_id AND
database_id = DB_ID()
) AND
o.[type] = 'U'
ORDER BY OBJECT_NAME(ix.object_id) ASC ;


--Encontrar indices que son actualizados pero nunca usados
USE WideWorldImporters;
GO
SELECT
o.name AS ObjectName ,
ix.name AS IndexName ,
ixu.user_seeks + ixu.user_scans + ixu.user_lookups AS user_reads ,
ixu.user_updates AS user_writes ,
SUM(p.rows) AS total_rows
FROM sys.dm_db_index_usage_stats ixu
INNER JOIN sys.indexes ix ON
ixu.object_id = ix.object_id AND
ixu.index_id = ix.index_id
INNER JOIN sys.partitions p ON
ixu.object_id = p.object_id AND
ixu.index_id = p.index_id
INNER JOIN sys.objects o ON
ixu.object_id = o.object_id
WHERE
ixu.database_id = DB_ID() AND
OBJECTPROPERTY(ixu.object_id, 'IsUserTable') = 1 AND
ixu.index_id > 0
GROUP BY
o.name ,
ix.name ,
ixu.user_seeks + ixu.user_scans + ixu.user_lookups ,
ixu.user_updates
HAVING ixu.user_seeks + ixu.user_scans + ixu.user_lookups = 0
ORDER BY
ixu.user_updates DESC,
o.name ,
ix.name ;

--Ver la fragmentacion de los indices
DECLARE @db_id SMALLINT, @object_id INT;
SET @db_id = DB_ID(N'WideWorldImporters');
SET @object_id = OBJECT_ID(N'WideWorldImporters.Sales.Orders');
SELECT
ixs.index_id AS idx_id,
ix.name AS ObjectName,
index_type_desc,
page_count,
avg_page_space_used_in_percent AS AvgPageSpacePct,
fragment_count AS frag_ct,
avg_fragmentation_in_percent AS AvgFragPct
FROM sys.dm_db_index_physical_stats
(@db_id, @object_id, NULL, NULL , 'Detailed') ixs
INNER JOIN sys.indexes ix ON
ixs.index_id = ix.index_id AND
ixs.object_id = ix.object_id
ORDER BY avg_fragmentation_in_percent DESC;

SELECT
(user_seeks + user_scans) * avg_total_user_cost * (avg_user_impact * 0.01) AS
IndexImprovement,
id.statement,
id.equality_columns,
id.inequality_columns,
id.included_columns
FROM sys.dm_db_missing_index_group_stats AS igs
INNER JOIN sys.dm_db_missing_index_groups AS ig
ON igs.group_handle = ig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details AS id
ON ig.index_handle = id.index_handle
ORDER BY IndexImprovement DESC;
