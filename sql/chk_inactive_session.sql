
select inst_id , count(*) from gv$session where  LAST_CALL_ET > (60*60) group by  inst_id ;


