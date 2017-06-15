--binds_peeked_passed_acs.sql

--Souexw https://bdrouvot.wordpress.com/page/10/
--IS_BIND_SENSITIVE: Tells you if optimizer peeked a bind variable value and if a different value may change the explain plan.
--IS_BIND_AWARE: Tells you if a query uses cursor sharing, occurs only after the query has been marked bind sensitive.

set linesi 200 pages 999 feed off verify off
col bind_name format a5
col end_time format a19
col start_time format a19
col peeked format a20

col passed format a20
 
alter session set nls_date_format='YYYY/MM/DD HH24:MI:SS';
alter session set nls_timestamp_format='YYYY/MM/DD HH24:MI:SS';
 
select
pee.sql_id,
ash.starting_time,
ash.end_time,
(EXTRACT(HOUR FROM ash.run_time) * 3600
                    + EXTRACT(MINUTE FROM ash.run_time) * 60
                    + EXTRACT(SECOND FROM ash.run_time)) run_time_sec,
pee.plan_hash_value,
pee.bind_name,
pee.bind_pos,
pee.bind_data peeked,
--first_value(pee.bind_data) over (partition by pee.sql_id,pee.bind_name,pee.bind_pos order by end_time rows 1 preceding) previous_peeked,
run_t.bind_data passed,
case when pee.bind_data =  first_value(pee.bind_data) over (partition by pee.sql_id,pee.bind_name,pee.bind_pos order by end_time rows 1 preceding) then 'NO' else 'YES' end "ACS"
from
(
select
p.sql_id,
p.sql_child_address,
p.sql_exec_id,
c.bind_name,
c.bind_pos,
c.bind_data
from
v$sql_monitor p,
xmltable
(
'/binds/bind' passing xmltype(p.binds_xml)
columns bind_name varchar2(30) path '/bind/@name',
bind_pos number path '/bind/@pos',
bind_data varchar2(30) path '/bind'
) c
where
p.binds_xml is not null
) run_t
,
(
select
p.sql_id,
p.child_number,
p.child_address,
c.bind_name,
c.bind_pos,
p.plan_hash_value,
case
     when c.bind_type = 1 then utl_raw.cast_to_varchar2(c.bind_data)
     when c.bind_type = 2 then to_char(utl_raw.cast_to_number(c.bind_data))
     when c.bind_type = 96 then to_char(utl_raw.cast_to_varchar2(c.bind_data))
     else 'Sorry: Not printable try with DBMS_XPLAN.DISPLAY_CURSOR'
end bind_data
from
v$sql_plan p,
xmltable
(
'/*/peeked_binds/bind' passing xmltype(p.other_xml)
columns bind_name varchar2(30) path '/bind/@nam',
bind_pos number path '/bind/@pos',
bind_type number path '/bind/@dty',
bind_data  raw(2000) path '/bind'
) c
where
p.other_xml is not null
) pee,
(
select
sql_id,
sql_exec_id,
max(sample_time - sql_exec_start) run_time,
max(sample_time) end_time,
sql_exec_start starting_time
from
v$active_session_history
group by sql_id,sql_exec_id,sql_exec_start
) ash
where
pee.sql_id=run_t.sql_id and
pee.sql_id=ash.sql_id and
run_t.sql_exec_id=ash.sql_exec_id and
pee.child_address=run_t.sql_child_address and
pee.bind_name=run_t.bind_name and
pee.bind_pos=run_t.bind_pos and
pee.sql_id like nvl('&sql_id',pee.sql_id)
order by 1,2,3,7 ;


select child_number,PLAN_HASH_VALUE, executions, buffer_gets,is_bind_sensitive, is_bind_aware,is_shareable  from v$sql where sql_id='&sql_id' ;
SELECT * FROM V$SQL_CS_HISTOGRAM WHERE sql_id='&sql_id' ;
SELECT * FROM V$SQL_CS_SELECTIVITY WHERE sql_id='&sql_id' ;
SELECT * FROM V$SQL_CS_STATISTICS WHERE sql_id='&sql_id' ;


