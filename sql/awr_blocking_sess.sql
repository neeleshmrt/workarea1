set linesize 200 
set pagesize 20000

SELECT  distinct a.sample_time,a.sql_id, a.blocking_session bkl_sess,a.blocking_session_serial# bkl_sess_serial   ,
a.user_id,a.module,s.sql_text
FROM  V$ACTIVE_SESSION_HISTORY a, v$sql s
where a.sql_id=s.sql_id
and blocking_session is not null
and a.user_id <> 0 
and a.sample_time between to_date('06/12/2016 23:50', 'dd/mm/yyyy hh24:mi') 
and to_date('07/12/2016 00:10', 'dd/mm/yyyy hh24:mi')
and a.event like '%enq%'
;

