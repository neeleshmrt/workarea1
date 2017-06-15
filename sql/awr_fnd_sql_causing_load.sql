set linesize 200 pages  50

alter session set nls_date_format = 'DD-MON-YYYY HH24:MI:SS' ;
Prompt " Enter Sample time in 18-FEB-16 09:30:00 format"

col wait_class for a20
col wait_class for a20
select INSTANCE_NUMBER,wait_class_id, wait_class, count(*) cnt
from dba_hist_active_sess_history
where 
--snap_id between 105305 and 105306 and 
--INSTANCE_NUMBER=2
   SAMPLE_TIME  between  to_date('&&Begin_Sample_Time','DD-MON-YY HH24:MI:SS') and to_date('&&End_Sample_Time','DD-MON-YY HH24:MI:SS')
group by INSTANCE_NUMBER  ,wait_class_id, wait_class
order by 1,4;

col event for a30

select event_id, event, count(*) cnt from dba_hist_active_sess_history
where 
--snap_id between  105305 and 105306 and 
INSTANCE_NUMBER=&Instance_no and
SAMPLE_TIME  between  '&Begin_Sample_Time' and '&End_Sample_Time' and
wait_class_id in (&&wait_class_id)
group by event_id, event
order by 3;

select sql_id, count( *) cnt from dba_hist_active_sess_history
where 
--snap_id between 105305 and 105306
INSTANCE_NUMBER=&Instance_no and
SAMPLE_TIME  between  '&&Begin_Sample_Time' and '&&End_Sample_Time'  and
 event_id in (&event_ids)
group by sql_id
having count(*)> 200
 order by 2 ;
