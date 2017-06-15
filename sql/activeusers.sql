---
--- LISTS ALL USERS
---
set echo off
set verify off
set pause off
set feedback on
set heading on
set linesize 200
set pagesize 2000

column "SID:SERIAL#" for a11
column USERINFO format a15
column "LOGON_TIME" for a20
column "CLIENT INFO" for a20 word
column CurrentSQL for a40 word
column STATE for a20 word
column SQL_cld_No for 99999

select   	ss.osuser||'/'||ss.username USERINFO, ss.sid||','||ss.serial# "SID:SERIAL#",
		replace(replace(replace(program,'(TNS V1-V3)',''),'','/Prod')
		,'','')||'-'||replace(replace(machine,'','/Prod'),
		'','')
		||'-'||client_info "CLIENT INFO",(sysdate-sql_exec_start)*24*60*60 Secs ,
		sa.sql_id||'/'||substr(sa.sql_text,1,80) CurrentSQL,
		decode(sw.wait_time,0,'Wait'||'/'||sw.event,'No wait/CPU') STATE,
		to_char(logon_time,'DD-Mon HH24:MI:SS') "LOGON_TIME" ,ss.SQL_CHILD_NUMBER SQL_cld_No
--		,ss.seconds_in_wait
from     	v$session ss,
		v$session_wait sw,
		v$sqlarea sa
where		ss.username is not null
  and		ss.status = 'ACTIVE'  
  and		ss.sid = sw.sid (+)  
  and		ss.sql_hash_value = sa.hash_value (+)   
--  and  ss.sid in (680,1099)
--and ss.sql_id in ('f4df2gxxuxjj6','fucjpq7w7gfw5')
order by	(sysdate-sql_exec_start)*24*60*60 asc
/
