 
prompt  ==============================
prompt  Initial Histogram distribution
prompt  ==============================
 
select
    endpoint_value,
    endpoint_number,
    to_date(to_char(trunc(endpoint_value)),'J') + mod(endpoint_value,1) d_val,
    lag(endpoint_value,1) over(order by endpoint_number) lagged_epv,
    endpoint_value -   lag(endpoint_value,1) over(order by endpoint_number)  as frequency
from    dba_tab_histograms
where
owner= '&Owner_Name'
and  table_name = '&Table_name'
and column_name = '&Column_name'
;
