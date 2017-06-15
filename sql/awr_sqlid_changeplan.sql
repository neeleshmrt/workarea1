SET LINESIZE 200 PAGESIZE 50
col BEGIN_INTERVAL_TIME for a17 HEADING 'BEGIN|INTERVAL|TIME' JUSTIFY RIGHT
col AVG_USER_IO_WAIT   HEADING 'AVG|USER_IO|WAIT'          JUSTIFY RIGHT
col AVG_USER_IO_WAIT HEADING 'AVG|USER_IO|WAIT'          JUSTIFY RIGHT
Col AVG_CLU_WAIT  HEADING 'AVG|CLU|WAIT'          JUSTIFY RIGHT
Col AVG_APP_WAIT  HEADING 'AVG|APP|WAIT'          JUSTIFY RIGHT
col AVG_CONCURRENT_WAIT  FOR 9999 HEADING 'AVG|CONCURR|WAIT'  JUSTIFY RIGHT
col AVG_CPU_WAIT HEADING 'AVG|CPU|WAIT'  JUSTIFY RIGHT
col AVG_ROWS  HEADING 'AVG|ROWS'  JUSTIFY RIGHT
col SNAP_ID  for 9999999
col  NODE for 99
alter session set nls_timestamp_format ='DD-MON-YYYY HH24:MI';

select 
 ss.snap_id, 
ss.instance_number node,
 begin_interval_time, sql_id, plan_hash_value PLAN_HASH,
nvl(executions_delta,0) execs,
trunc ( (elapsed_time_delta/decode(nvl(executions_delta,0),0,1,executions_delta))/1000000 , 2 ) avg_etime,
trunc ( (buffer_gets_delta/decode(nvl(buffer_gets_delta,0),0,1,executions_delta)), 2 ) avg_lio,
trunc ( (disk_reads_delta/decode(nvl(disk_reads_delta,0),0,1,executions_delta)) , 2 )  avg_pio,
trunc ( (rows_processed_delta/decode(nvl(rows_processed_delta,0),0,1,executions_delta)) , 0 )  avg_rows,
trunc ( (CPU_TIME_DELTA/decode(nvl(CPU_TIME_DELTA,0),0,1,executions_delta))/1000000 , 2 ) avg_cpu_wait,
trunc ( (IOWAIT_DELTA/decode(nvl(IOWAIT_DELTA,0),0,1,executions_delta))/1000000  , 2 ) avg_user_io_wait,
trunc ( (CLWAIT_DELTA/decode(nvl(CLWAIT_DELTA,0),0,1,executions_delta))/1000000  , 2 ) avg_clu_wait ,
trunc ( (APWAIT_DELTA/decode(nvl(APWAIT_DELTA,0),0,1,executions_delta))/1000000  , 2 ) avg_app_wait,
trunc ( (CCWAIT_DELTA/decode(nvl(CCWAIT_DELTA,0),0,1,executions_delta))/1000000  , 2 ) avg_concurrent_wait
from DBA_HIST_SQLSTAT S, DBA_HIST_SNAPSHOT SS
where sql_id in '&SQLID' --Add SQLid here 
--AND plan_hash_value=&plan_hash_value
and ss.snap_id = S.snap_id
and ss.instance_number = S.instance_number
and executions_delta > 0
order by begin_interval_time ;

prompt  "To get best plan awrsql_id_bestplan.sql "
