 set linesize 200 pagesize 20000
 col SQL_TEXT for a50 
COL OSUSER FOR A10
col username  FOR A10
col PLAN_HASH_VALUE for 999999999999999
SELECT sysdate,a.username, a.sid, a.serial#,c.sql_id,c.PLAN_HASH_VALUE,b.blocks*8192/1024/1024/1024 TEMP_GB , c.sql_text
FROM v$session a, v$tempseg_usage b, v$sqlarea c
WHERE b.tablespace = 'TEMP'
and a.saddr = b.session_addr
AND c.address= a.sql_address
AND c.hash_value = a.sql_hash_value 
and  b.blocks*8192/1024/1024/1024  > 1;

