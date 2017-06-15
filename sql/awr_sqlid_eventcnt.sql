
set linesize 200 pageszie 20000
col event for a30
 SELECT  sql_id,event ,count(*)    from dba_hist_active_sess_history h ,  dba_hist_snapshot x WHERE x.snap_id = h.snap_id AND    x.dbid = h.dbid AND  x.instance_number = h.instance_number  and  h.sql_id='&sql_id'AND  x.end_interval_time >=  TO_DATE('&start_Time','DD-MON-YYYY HH24:MI') AND  x.begin_interval_time <= TO_DATE('&end_Time','DD-MON-YYYY HH24:MI') group by    sql_id,event ;
