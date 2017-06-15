
-- Instance Specific

set linesize 200 pagesize 20000

-- If your database is currently experiencing a high percentage of waits/bottlenecks vs. smoothly running operations
-- The Database CPU Time Ratio is calculated by dividing the amount of CPU expended in the database by the amount of "database time," -- database time =  time spent by the database on user-level calls (with instance background process activity being excluded).
-- High values (90-95+ percent) are good and indicate few wait/bottleneck actions


select  METRIC_NAME,
        VALUE
from    SYS.V_$SYSMETRIC
where   METRIC_NAME IN ('Database CPU Time Ratio',
                        'Database Wait Time Ratio') AND
        INTSIZE_CSEC = 
        (select max(INTSIZE_CSEC) from SYS.V_$SYSMETRIC); 

-- Time Spend by database on user-level calls 

alter session set nls_date_format = 'DD-MON-YYYY HH24:MI:SS' ;

set pagesize 50

select  end_time,
        value  "Database CPU Time Ratio"
from    sys.v_$sysmetric_history
where   metric_name = 'Database CPU Time Ratio'
order by 1;

-- what types of user activities are responsible for making the database work so hard

select  case db_stat_name
            when 'parse time elapsed' then 
                'soft parse time'
            else db_stat_name
            end db_stat_name,
        case db_stat_name
            when 'sql execute elapsed time' then 
                time_secs - plsql_time 
            when 'parse time elapsed' then 
                time_secs - hard_parse_time
            else time_secs
            end time_secs,
        case db_stat_name
            when 'sql execute elapsed time' then 
                round(100 * (time_secs - plsql_time) / db_time,2)
            when 'parse time elapsed' then 
                round(100 * (time_secs - hard_parse_time) / db_time,2)  
            else round(100 * time_secs / db_time,2)  
            end pct_time
from
(select stat_name db_stat_name,
        round((value / 1000000),3) time_secs
    from sys.v_$sys_time_model
    where stat_name not in('DB time','background elapsed time',
                            'background cpu time','DB CPU')),
(select round((value / 1000000),3) db_time 
    from sys.v_$sys_time_model 
    where stat_name = 'DB time'),
(select round((value / 1000000),3) plsql_time 
    from sys.v_$sys_time_model 
    where stat_name = 'PL/SQL execution elapsed time'),
(select round((value / 1000000),3) hard_parse_time 
    from sys.v_$sys_time_model 
    where stat_name = 'hard parse elapsed time')
order by 2 desc;


--overall database efficiency by querying the 

select  CASE METRIC_NAME
            WHEN 'SQL Service Response Time' then 'SQL Service Response Time (secs)'
            WHEN 'Response Time Per Txn' then 'Response Time Per Txn (secs)'
            ELSE METRIC_NAME
            END METRIC_NAME,
                CASE METRIC_NAME
            WHEN 'SQL Service Response Time' then ROUND((MINVAL / 100),2)
            WHEN 'Response Time Per Txn' then ROUND((MINVAL / 100),2)
            ELSE MINVAL
            END MININUM,
                CASE METRIC_NAME
            WHEN 'SQL Service Response Time' then ROUND((MAXVAL / 100),2)
            WHEN 'Response Time Per Txn' then ROUND((MAXVAL / 100),2)
            ELSE MAXVAL
            END MAXIMUM,
                CASE METRIC_NAME
            WHEN 'SQL Service Response Time' then ROUND((AVERAGE / 100),2)
            WHEN 'Response Time Per Txn' then ROUND((AVERAGE / 100),2)
            ELSE AVERAGE
            END AVERAGE
from    SYS.V_$SYSMETRIC_SUMMARY 
where   METRIC_NAME in ('CPU Usage Per Sec',
                      'CPU Usage Per Txn',
                      'Database CPU Time Ratio',
                      'Database Wait Time Ratio',
                      'Executions Per Sec',
                      'Executions Per Txn',
                      'Response Time Per Txn',
                      'SQL Service Response Time',
                      'User Transaction Per Sec')
ORDER BY 1
;




@ash_workload_11g.sql


--global wait times to understand waits and bottlenecks
select  WAIT_CLASS,
        TOTAL_WAITS,
        round(100 * (TOTAL_WAITS / SUM_WAITS),2) PCT_WAITS,
        ROUND((TIME_WAITED / 100),2) TIME_WAITED_SECS,
        round(100 * (TIME_WAITED / SUM_TIME),2) PCT_TIME
from
(select WAIT_CLASS,
        TOTAL_WAITS,
        TIME_WAITED
from    V$SYSTEM_WAIT_CLASS
where   WAIT_CLASS != 'Idle'),
(select  sum(TOTAL_WAITS) SUM_WAITS,
        sum(TIME_WAITED) SUM_TIME
from    V$SYSTEM_WAIT_CLASS
where   WAIT_CLASS != 'Idle')
order by 5 desc;

 Prompt " Date Format : 19-APR-16 02:00:00 PM "


col USERNAME for a10
col  WAIT_EVENT for a30
select  sess_id,sql_id ,
        username,
        program,
        wait_event,
        sess_time,
        round(100 * (sess_time / total_time),2) pct_time_waited
from
(
select a.session_id sess_id,a.sql_id sql_id,
        decode(session_type,'background',session_type,c.username) username,
        a.program program,
        b.name wait_event,
        sum(a.time_waited) sess_time
from    sys.v_$active_session_history a,
        sys.v_$event_name b,
        sys.dba_users c
where   a.event# = b.event# and
        a.user_id = c.user_id and
        sample_time > to_date('&&begintime','DD-MON-YY HH24:MI:SS') and 
        sample_time < to_date('&&endtime','DD-MON-YY HH24:MI:SS')  and
        b.wait_class = '&&Wait_class'
group by a.session_id,a.sql_id,
        decode(session_type,'background',session_type,c.username),
        a.program,
        b.name),
(select sum(a.time_waited) total_time
from    sys.v_$active_session_history a,
        sys.v_$event_name b
where   a.event# = b.event# and
        sample_time >  to_date('&begintime','DD-MON-YY HH24:MI:SS')  and 
        sample_time <  to_date('&endtime','DD-MON-YY HH24:MI:SS')  and
        b.wait_class = '&Wait_class')
order by 6 desc;

set long 5000

select sql_id,sql_text from gv$sql where sql_id='&sql_id';

col  EVENT  for a30 
col  OWNER  for a20
col OBJECT_NAME  for a30 


select event,
        time_waited,
        owner,
        object_name,
        current_file#,
        current_block# 
from    sys.v_$active_session_history a,
        sys.dba_objects b 
where   sql_id = '&&sql_id' and
        a.current_obj# = b.object_id and
        time_waited <> 0;


col sql_text for a70


select *
from
(select sql_text,
        sql_id,
        (elapsed_time/1000000) TSec,
        (cpu_time/1000000) CPU_SEC,
        (user_io_wait_time/1000000) user_io_wait_SEC ,
(APPLICATION_WAIT_TIME/1000000) app_wait_SEC,
(CONCURRENCY_WAIT_TIME/1000000) concurrency_wait_SEC,
(CLUSTER_WAIT_TIME/1000000) cluster_wait_SEC,
 BUFFER_GETS
from    sys.v_$sqlarea
order by 3 desc)
where rownum < 6;
