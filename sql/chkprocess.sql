set lines 200 pagesize 20000

SELECT INST_ID "ID",RESOURCE_NAME "RESOURCE",CURRENT_UTILIZATION "CURRENT",MAX_UTILIZATION "MAX",INITIAL_ALLOCATION "INITIAL",LIMIT_VALUE FROM
GV$RESOURCE_LIMIT WHERE RESOURCE_NAME in ( 'sessions','processes');

select inst_id,count(*) from gv$session group by  inst_id;


col BEGIN_INTERVAL_TIME for a28
col END_INTERVAL_TIME for a28
col RESOURCE_NAME for a10
SELECT A.SNAP_ID,A.INSTANCE_NUMBER "ID",B.BEGIN_INTERVAL_TIME,B.END_INTERVAL_TIME,A.RESOURCE_NAME,
CURRENT_UTILIZATION "CURRENT",MAX_UTILIZATION "MAX"
FROM WRH$_RESOURCE_LIMIT A, WRM$_SNAPSHOT B
WHERE A.RESOURCE_NAME LIKE '%session%'
AND A.SNAP_ID=B.SNAP_ID
AND A.INSTANCE_NUMBER= B.INSTANCE_NUMBER
order by A.SNAP_ID,A.RESOURCE_NAME;


 select  spid os_pid  ,USERNAME , PROGRAM from  v$process  where addr  in ( select paddr from v$session ) and pname is null and spid is not null order by 2;



select USERNAME,SCHEMANAME,PROCESS,PROGRAM,MODULE  from v$session where  paddr   in (  select  addr   from v$process )

select  USERNAME ,count(*) from  v$session where  paddr   in (  select  addr   from v$process )  order by 2;

 select  USERNAME ,count(*) from  v$session where  USERNAME is not null  and  paddr   in (  select  addr   from v$process ) group by  USERNAME  order by 2;


