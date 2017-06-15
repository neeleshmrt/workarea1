set linesize 200 pages 1000
ttitle "Blocking Information"
prompt
prompt -------- General Blocking Info ---------
col MACHINE for a10
col osuser for a10
col username for a20
COL program FOR A15
col EVENT for a15
col  blocking_session for 9999999
col action for a10
col state for a10


SELECT inst_id, sid, serial#, blocking_session_status, blocking_session FROM   gv$session WHERE  blocking_session IS NOT NULL;
select inst_id, sid, serial#, osuser, username, status, sql_id,event ,prev_sql_id, last_call_et/60 lmins, machine, program from gv$session
where sid in (select blocking_session from gv$session where blocking_session_status='VALID');
prompt
prompt -------- Detailed Blocking Info --------

set linesize 200 pages 1000
column sess format A20
SELECT substr(DECODE(request,0,'Holder: ','Waiter: ')||sid,1,12) sess,
       id1, id2, lmode, request, type, inst_id
 FROM GV$LOCK
WHERE (id1, id2, type) IN
   (SELECT id1, id2, type FROM GV$LOCK WHERE request>0)
     ORDER BY id1, request;

prompt
prompt -------- Blocking If caused by ENQ --------
set linesize 200 pages 1000
SELECT sid, serial#, username, STATUS, state, event,
blocking_session, seconds_in_wait, wait_time, action, logon_time
FROM gv$session WHERE state IN ('WAITING') AND wait_class != 'Idle'
AND event LIKE '%enq%'
AND TYPE='USER';
prompt

prompt -------- Locked Objects ----------

set linesize 200 pages 1000
COLUMN owner FORMAT A36
COLUMN username FORMAT A25
COLUMN object_owner FORMAT A25
COLUMN object_name FORMAT A40
COLUMN locked_mode FORMAT A25
SELECT b.inst_id AS Instance,
       b.session_id AS sid,
       NVL(b.oracle_username, '(oracle)') AS username,
       a.owner AS object_owner,
       a.object_name,
       Decode(b.locked_mode, 0, 'None',
                             1, 'Null (NULL)',
                             2, 'Row-S (SS)',
                             3, 'Row-X (SX)',
                             4, 'Share (S)',
                             5, 'S/Row-X (SSX)',
                             6, 'Exclusive (X)',
                             b.locked_mode) locked_mode,
       b.os_user_name
FROM   dba_objects a,
       gv$locked_object b
WHERE  a.object_id = b.object_id
ORDER BY 1, 2, 3, 4,5;

