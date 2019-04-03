USE MemDemo
GO

--Se puede declarar un tipo tabla (RAM)
--Asi declaramos comunmente una variable
DECLARE @tvTableD TABLE  
    ( Column1   INT   NOT NULL ,  
      Column2   CHAR(10) );

--Pero lo podemos mejor
--Creando un tipo de dato tabla optimizada en memoria
CREATE TYPE dbo.typeTableD  
    AS TABLE  
    (  
        Column1  INT   NOT NULL   INDEX ix1,  
        Column2  CHAR(10)  
    )  
    WITH  
        (MEMORY_OPTIMIZED = ON);


--Ya podria utilizar la variable tabla
SET NoCount ON;  
DECLARE @tvTableD dbo.typeTableD  
;  
INSERT INTO @tvTableD (Column1) values (1), (2)  
;  
SELECT * from @tvTableD;  
go







