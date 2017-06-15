SELECT  event ,count(*) 
FROM dba_hist_active_sess_history h 
,  dba_hist_snapshot x 
WHERE x.snap_id = h.snap_id 
AND  x.dbid = h.dbid 
AND  x.instance_number = h.instance_number 
AND  x.end_interval_time >=  TO_DATE('&start_Time','yyyymmddhh24mi')
AND  x.begin_interval_time <= TO_DATE('&start_Time','yyyymmddhh24mi')
GROUP BY events    ;

