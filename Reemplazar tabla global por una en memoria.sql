--Tabla temporal y variable de tabla mas rapida con optmizacion para memoria

--Se debe crear la tabla en implementacion y no en ejecucion

--Tenemos la siguiente tabla global
CREATE TABLE ##tempGlobalB  
    (  
        Column1   INT   NOT NULL ,  
        Column2   NVARCHAR(4000)  
    ); 

--Considerar reemplazar la tabla temporal global
--por la siguiente tabla otimizada para memoria que tiene
--DURABILITY=SCHEMA

CREATE TABLE dbo.soGlobalB  
(  
    Column1   INT   NOT NULL   INDEX ix1 NONCLUSTERED,  
    Column2   NVARCHAR(4000)  
)  
    WITH  
        (MEMORY_OPTIMIZED = ON,  
        DURABILITY        = SCHEMA_ONLY);

--Luego ya intente eliminar, despues de usarla
DROP TABLE dbo.soGlobalB 
