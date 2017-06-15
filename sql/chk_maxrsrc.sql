ttitle "Resources Reaching Max Threshold"

select (CASE
WHEN ( Round ((current_utilization/decode(instr(limit_value,'UNLIMITED'),0,to_number(limit_value),999999999)*100),2)) > 90 THEN 'CRITICAL'
WHEN ( Round ((current_utilization/decode(instr(limit_value,'UNLIMITED'),0,to_number(limit_value),999999999)*100),2)) between 80 and 90 THEN 'WARNING'
END) Alert,
inst_id,
resource_name,
current_utilization,
max_utilization,
decode(instr(limit_value,'UNLIMITED'),0,to_number(limit_value),999999999) limit_value,
Round ((current_utilization/decode(instr(limit_value,'UNLIMITED'),0,to_number(limit_value),999999999)*100),2) pct_usage
from gv$resource_limit
where Round ((current_utilization/decode(instr(limit_value,'UNLIMITED'),0,to_number(limit_value),999999999)*100),2) >= 70
and resource_name in ('processes', 'sessions')
;

