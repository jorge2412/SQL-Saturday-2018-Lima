IF EXISTS(SELECT *
FROM sys.server_event_sessions
WHERE name='ActualQueryPlans')
DROP EVENT SESSION ActualQueryPlans
ON SERVER;
GO

--Creando un Extend Event
CREATE EVENT SESSION ActualQueryPlans
ON SERVER
ADD EVENT sqlserver.query_post_execution_showplan(
ACTION (sqlserver.database_name,
sqlserver.client_hostname,
sqlserver.client_app_name,
sqlserver.plan_handle,
sqlserver.sql_text,
sqlserver.tsql_stack,
package0.callstack,
sqlserver.query_hash,
sqlserver.session_id,
sqlserver.request_id)
WHERE
sqlserver.database_name='WideWorldImporters' AND
object_type = 'ADHOC'
)
ADD TARGET package0.event_file(SET filename=N'D:\Jorge Muchaypiña\ActualQueryPlans.xel',
max_file_size=(5),max_rollover_files=(4)),
ADD TARGET package0.ring_buffer
WITH (MAX_DISPATCH_LATENCY=5SECONDS, TRACK_CAUSALITY=ON);
GO
ALTER EVENT SESSION ActualQueryPlans
ON SERVER
STATE=START;
GO


--Luego de eso se puede deshabilitar los eventos extendidos
--Disable extended event session
ALTER EVENT SESSION ActualQueryPlans
ON SERVER
STATE=STOP;
GO

--Drop extended event session
IF EXISTS(SELECT *
FROM sys.server_event_sessions
WHERE name='ActualQueryPlans')
DROP EVENT SESSION ActualQueryPlans
ON SERVER;
GO