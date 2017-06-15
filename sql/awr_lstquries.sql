-- gets most expensive queries based on  Execution Time , LIO , POI , Average
-- (by time spent, change "order by" to use another metric)
-- after a specific date
 
select
   sub.sql_id,
   NVL(sub.execs_since_date, 0) Total_execs ,
   NVL(sub.seconds_since_date, 0) Total_seconds,
   sub.seconds_since_date/decode(execs_since_date,0,1,execs_since_date)  Avg_execs_sec,
   sub.gets_since_date Total_LOI,
   sub.gets_since_date/decode(execs_since_date,0,1,execs_since_date)  Avg_LIO_sec,
   sub.diskread_since_date Total_POI,
   sub.diskread_since_date/decode(execs_since_date,0,1,execs_since_date)  Avg_PIO_sec,
   sub.cpu_since_date  Total_CPU,
   sub.cpu_since_date/decode(execs_since_date,0,1,execs_since_date)  Avg_CPU_sec
from
   ( -- sub to sort before rownum
     select
        sql_id,
        round(sum(elapsed_time_delta)/1000000) as seconds_since_date,
        sum(executions_delta) as execs_since_date,
        sum(buffer_gets_delta) as gets_since_date,
        sum(disk_reads_delta) as diskread_since_date,
        sum(CPU_TIME_DELTA)   as cpu_since_date
     from
        dba_hist_snapshot natural join dba_hist_sqlstat
     where
        begin_interval_time between  to_date('&start_YYYYMMDD','YYYY-MM-DD') and to_date('&end_YYYYMMDD','YYYY-MM-DD')
     group by
        sql_id
   ) sub
     order by 
--            sub.cpu_since_date/decode(execs_since_date,0,1,execs_since_date) desc
--          sub.seconds_since_date/decode(execs_since_date,0,1,execs_since_date)  desc  --Avg_execs_sec
--        sub.gets_since_date/decode(execs_since_date,0,1,execs_since_date)     desc  --Avg_LIO_sec 
--        sub.diskread_since_date/decode(execs_since_date,0,1,execs_since_date)  desc --Avg_PIO_sec
   2 desc
where
   rownum < 30
;
