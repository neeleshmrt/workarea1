accept days prompt 'Enter days > '

col dbname new_value _dbname

select name dbname from v$database;

prompt &_dbname
alter session set nls_date_format = 'dd/mm/yyyy hh24:mi';

set head off feed off pages 0 lines 500 trim on trims on veri off echo off

spool  sysmetric_outp_&_dbname..log

select 'DB Name' || '|' ||
       'Begin Time' || '|' ||
       'End Time' || '|' ||
       'Physical Read Total Bytes Per Sec' || '|' ||
       'Physical Write Total Bytes Per Sec' || '|' ||
       'Redo Generated Per Sec' || '|' ||
       'Physical Read Total IO Requests Per Sec' || '|' ||
       'Physical Write Total IO Requests Per Sec' || '|' ||
       'Redo Writes Per Sec' || '|' ||
       'Current OS Load' || '|' ||
       'CPU Usage Per Sec' || '|' ||
       'Host CPU Utilization (%)' || '|' ||
       'Network Traffic Volume Per Sec' || '|' ||
       'Snap ID'
from   dual;

select '&_dbname' || '|' ||
       min(begin_time) || '|' ||
       max(end_time) || '|' ||
       sum(case metric_name when 'Physical Read Total Bytes Per Sec' then maxval end) || '|' ||
       sum(case metric_name when 'Physical Write Total Bytes Per Sec' then maxval end) || '|' ||
       sum(case metric_name when 'Redo Generated Per Sec' then maxval end) || '|' ||
       sum(case metric_name when 'Physical Read Total IO Requests Per Sec' then maxval end) || '|' ||
       sum(case metric_name when 'Physical Write Total IO Requests Per Sec' then maxval end) || '|' ||
       sum(case metric_name when 'Redo Writes Per Sec' then maxval end) || '|' ||
       sum(case metric_name when 'Current OS Load' then maxval end) || '|' ||
       sum(case metric_name when 'CPU Usage Per Sec' then maxval end) || '|' ||
       sum(case metric_name when 'Host CPU Utilization (%)' then maxval end) || '|' ||
       sum(case metric_name when 'Network Traffic Volume Per Sec' then maxval end) || '|' ||
       snap_id
from   dba_hist_sysmetric_summary
where  to_char(begin_time, 'DY') not in ('SAT', 'SUN')
and    begin_time >= trunc(sysdate - &days)
--and    dbid = (select dbid from v$database)
group by snap_id
order by snap_id;

spool off

