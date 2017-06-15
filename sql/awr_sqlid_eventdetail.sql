
set linesize 200 pageszie 20000
col event for a30
col  sample_time  for a25
col p1text for a15
col p2text for a15
col p3text for a15

SELECT  event ,count(*) 
FROM dba_hist_active_sess_history h 
,  dba_hist_snapshot x 
WHERE x.snap_id = h.snap_id 
AND  x.dbid = h.dbid 
AND  x.instance_number = h.instance_number 
and  h.sql_id='&sql_id'
AND  x.end_interval_time >=  TO_DATE('&&start_Time','yyyymmddhh24mi')
AND  x.begin_interval_time <= TO_DATE('&&end_Time','yyyymmddhh24mi')
GROUP BY events    

SELECT sample_time,sql_id,blocking_session,blocking_inst_id,event,p1,p1text,p2,p2text,p3,p3text  from dba_hist_active_sess_history h ,  dba_hist_snapshot x WHERE x.snap_id = h.snap_id AND  x.dbid = h.dbid AND  x.instance_number = h.instance_number  and  h.sql_id='&sql_id'AND  x.end_interval_time >=  TO_DATE('&start_Time','DD-MON-YYYY HH24:MI') AND  x.begin_interval_time <= TO_DATE('&end_Time','DD-MON-YYYY HH24:MI')  order by 1  ;
