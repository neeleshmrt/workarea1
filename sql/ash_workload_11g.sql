set linesize 200 pagesize 50
alter session set nls_date_format = 'DD-MON-YYYY HH24:MI:SS' ;

SELECT sysmetric_history.sample_time,
  cpu/60 AS cpu,
  bcpu/60 AS bcpu,
  DECODE(SIGN((cpu+bcpu)/60-cpu_ora_consumed), -1, 0, ((cpu+bcpu)/60-cpu_ora_consumed)) AS cpu_ora_wait,
  scheduler/60 AS scheduler,
  uio/60 AS uio,
  sio/60 AS sio,
  concurrency/60 AS concurrency,
  application/60 AS application,
  COMMIT/60 AS COMMIT,
  configuration/60 AS configuration,
  administrative/60 AS administrative,
  network/60 AS network,
  queueing/60 AS queueing,
  clust/60 AS clust,
  other/60 AS other
FROM
  (SELECT
     TRUNC(sample_time,'MI') AS sample_time,
     DECODE(session_state,'ON CPU',DECODE(session_type,'BACKGROUND','BCPU','ON CPU'), wait_class) AS wait_class
   FROM v$active_session_history
   WHERE sample_time>sysdate-INTERVAL '1' HOUR
   AND sample_time<=TRUNC(SYSDATE,'MI')) ash
   PIVOT (COUNT(*) FOR wait_class IN ('ON CPU' AS cpu,'BCPU' AS bcpu,'Scheduler' AS scheduler,'User I/O' AS uio,'System I/O' AS sio,
   'Concurrency' AS concurrency,'Application' AS application,'Commit' AS COMMIT,'Configuration' AS configuration,
   'Administrative' AS administrative,'Network' AS network,'Queueing' AS queueing,'Cluster' AS clust,'Other' AS other)) ash,
   (SELECT
      TRUNC(begin_time,'MI') AS sample_time,
      VALUE/100 AS cpu_ora_consumed
    FROM v$sysmetric_history
    WHERE GROUP_ID=2
    AND metric_name='CPU Usage Per Sec') sysmetric_history
WHERE ash.sample_time (+)=sysmetric_history.sample_time
ORDER BY sample_time;
