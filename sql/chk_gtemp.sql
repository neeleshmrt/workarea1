ttitle " Global Temp Space "
set linesize 200 pages 1000
SELECT
(CASE
WHEN (mb_used / mb_total) * 100 >  90 THEN 'CRITICAL'
WHEN (mb_used / mb_total) * 100 between  80 and 90 THEN 'WARNING'
ELSE 'N/A'
END)  alert,
inst_id,
tablespace,
mb_total,
mb_used,
(mb_used / mb_total) * 100 percent_utilized
FROM (  SELECT A.inst_id,
A.tablespace tablespace,
D.mb_total,
SUM (A.blocks * D.block_size) / 1024 / 1024 mb_used,
D.mb_total - SUM (A.blocks * D.block_size) / 1024 / 1024  mb_free
FROM gv$tempseg_usage A,
(  SELECT B.INST_ID,
B.name,
C.block_size,
SUM (C.bytes) / 1024 / 1024 mb_total
FROM gv$tablespace B, gv$tempfile C
WHERE B.ts# = C.ts# AND c.inst_id = b.inst_id
GROUP BY B.INST_ID, B.name, C.block_size) D
WHERE A.tablespace = D.name AND A.inst_id = D.inst_id
GROUP BY a.inst_id, A.tablespace, D.mb_total);
