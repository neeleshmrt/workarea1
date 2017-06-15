-------------------------------------------------------------------------------------------------------
--
-- File name:   build_bind_sqlmonitor.sql
--
-- Purpose:     Build SQL*Plus script with variable definitions from gv$sql_monitor.
--
-- Description: 

-- Usage:       This scripts prompts for three values. Provide input for at least one prompt and rest
--				is self explanatory.
--
--
-------------------------------------------------------------------------------------------------------

accept key      prompt 'Please enter the value for Key if known       : '
accept sid      prompt 'Please enter the value for Sid if known       : '
accept sql_id   prompt 'Please enter the value for sql_id if known    : '


set pages 900
set feed off
set echo off
set verify off
set head on
set linesize 200
column key format 999999999999999
column username format a10 trunc
column module format a20 trunc
column program format a15 trunc
column first_refresh_time format a20 trunc
column sql_text format a20

select key,status,username,module,sid,sql_id,to_char(first_refresh_time,'MM/DD/YY HH24:MI:SS') as first_refresh_time,program,
substr(sql_text,1,20)  as sql_text
from v$sql_monitor
where sid = nvl('&sid',sid)
  and key = nvl('&key',key)
  and sql_id = nvl('&sql_id',sql_id)
order by first_refresh_time desc;
  
accept key1      prompt 'Please enter Key from above       : '

set head off
select  'variable ' ||  replace(name,':','') || ' ' || dtystr || ';' from 
(select XMLTYPE.createXML(binds_xml) confval
from v$sql_monitor
where key=&key1) v,
xmltable('/binds/bind' passing v.confval
      columns
         name varchar2(25) path '@name',
         dtystr varchar2(25) path '@dtystr');
		 
select  case when dtystr like '%CHAR%' then 'exec ' || name || ' ' || ':=' || ' ' || '''' || value || '''' || ';'
             when dtystr like '%NUMB%' then 'exec ' || name || ' ' || ':=' || ' ' || value ||  ';' 
	    end as h
from 
(select XMLTYPE.createXML(binds_xml) confval
from v$sql_monitor
where key=&key1) v,
xmltable('/binds/bind' passing v.confval
      columns
	     name varchar2(25) path '@name',
	     dtystr varchar2(25) path '@dtystr',
         value VARCHAR2(4000) path '.');
		 
select sql_text ||';' from v$sql_monitor where key=&key1;

undefine sid
undefine key
undefine sql_id
undefine key1
set feed on
set head on
set verify on

