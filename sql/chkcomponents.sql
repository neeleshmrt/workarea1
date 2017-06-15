set line 200;
set pagesize 9999;
col COMP_ID format a15;
col COMP_NAME format a50;
select COMP_ID,COMP_NAME,VERSION,STATUS from dba_registry;

select * from v$option order by parameter;
