set linesize 200 pagesize 20000
select ss.instance_number node,begin_interval_time ,NUM_PROCESSES from DBA_HIST_PROCESS_MEM_SUMMARY  S, DBA_HIST_SNAPSHOT SS
 where ss.snap_id = S.snap_id and  ss.instance_number = S.instance_number i
--and  ss.instance_number =1 
and begin_interval_time > sysdate-2 order by begin_interval_time
;
