-- Set for 10 Hours 

select sql_id,max(TEMP_SPACE_ALLOCATED)/(1024*1024*1024) gig
from DBA_HIST_ACTIVE_SESS_HISTORY
where
sample_time > sysdate-10/24  and
TEMP_SPACE_ALLOCATED > (2*1024*1024*1024)
group by sql_id order by sql_id;

