ttitle "ASM diskgroups with critical free space"
set linesize 200 pages 1000
SELECT (CASE
	WHEN (total_mb/1024) >= 2000 AND (free_mb/1024) < 150 THEN 'CRITICAL'
	WHEN (total_mb/1024) < 2000 AND (free_mb/total_mb*100) < 10 THEN 'CRITICAL'
	WHEN (free_mb/total_mb*100) between 10 and 15 THEN 'WARNING'
         ELSE 'N/A'
    END) Alert
 ,  S.NAME
 ,  S.TOTAL_MB/1024
 ,  S.FREE_MB/1024
 ,  ROUND(S.free_mb/S.total_mb*100, 2) pct_free
 ,  S.STATE
 ,  S.OFFLINE_DISKS
 ,  v.usage
 from
    v$ASM_DISKGROUP_STAT s LEFT OUTER JOIN  V$ASM_VOLUME V
    on (s.group_number = v.group_number)
 where (s.free_mb/s.total_mb*100) <= 15
 and  v.usage is null;
