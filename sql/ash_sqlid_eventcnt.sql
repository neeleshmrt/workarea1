select event,count(*)  
from    sys.v_$active_session_history a 
where   sql_id = '&sql_id'  group by event;

