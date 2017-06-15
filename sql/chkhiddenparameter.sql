
set linesize 200 pagesize 2000

col  Param  for a40
col  SessionVal  for a20
col InstanceVal for a20
col Descr  for a50
SELECT 
a.ksppinm Param , 
b.ksppstvl SessionVal ,
c.ksppstvl InstanceVal,
a.ksppdesc Descr 
FROM 
x$ksppi a , 
x$ksppcv b , 
x$ksppsv c
WHERE 
a.ksppinm='&Hidden_Param' and 
a.indx = b.indx AND 
a.indx = c.indx AND 
a.ksppinm LIKE '/_%' escape '/'
ORDER BY
1
/
