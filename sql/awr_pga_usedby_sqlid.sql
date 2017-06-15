 
set linesize 200 pagesize 20000
col sample_time for a30
col  SQL_PLAN_HASH_VALUE for a15
col  sql_plan_operation for a20
col event for a30
col PGA_allocated_mb  for 99999999.99
select sample_time ,session_id sid,session_serial# serial#, sql_id,SQL_PLAN_HASH_VALUE hash, sql_plan_operation,event,pga_allocated/1024/1024 PGA_allocated_mb
from dba_hist_active_sess_history
where sql_id is not null and sample_time  > sysdate - 2 
order by pga_allocated desc ;
