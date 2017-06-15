SELECT
  sysmetric_history.sample_time,
  cpu,
  bcpu,
  DECODE(SIGN((cpu+bcpu)-cpu_ora_consumed), -1, 0, ((cpu+bcpu)-cpu_ora_consumed)) AS cpu_ora_wait,
  scheduler,
  uio,
  sio,
  concurrency,
  application,
  COMMIT,
  configuration,
  administrative,
  network,
  queueing,
  clust,
  other
FROM
  (SELECT
     TRUNC(sample_time,'MI') AS sample_time,
     SUM(DECODE(session_state,'ON CPU',DECODE(session_type,'BACKGROUND',0,1),0))/60 AS cpu,
     SUM(DECODE(session_state,'ON CPU',DECODE(session_type,'BACKGROUND',1,0),0))/60 AS bcpu,
     SUM(DECODE(wait_class,'Scheduler',1,0))/60 AS scheduler,
     SUM(DECODE(wait_class,'User I/O',1,0))/60 AS uio,
     SUM(DECODE(wait_class,'System I/O',1,0))/60 AS sio,
     SUM(DECODE(wait_class,'Concurrency',1,0))/60 AS concurrency,
     SUM(DECODE(wait_class,'Application',1,0))/60 AS application,
     SUM(DECODE(wait_class,'Commit',1,0))/60 AS COMMIT,
     SUM(DECODE(wait_class,'Configuration',1,0))/60 AS configuration,
     SUM(DECODE(wait_class,'Administrative',1,0))/60 AS administrative,
     SUM(DECODE(wait_class,'Network',1,0))/60 AS network,
     SUM(DECODE(wait_class,'Queueing',1,0))/60 AS queueing,
     SUM(DECODE(wait_class,'Cluster',1,0))/60 AS clust,
     SUM(DECODE(wait_class,'Other',1,0))/60 AS other
   FROM v$active_session_history
   WHERE sample_time>sysdate- INTERVAL '1' HOUR
   AND sample_time<=TRUNC(SYSDATE,'MI')
   GROUP BY TRUNC(sample_time,'MI')) ash,
  (SELECT
     TRUNC(begin_time,'MI') AS sample_time,
     VALUE/100 AS cpu_ora_consumed
   FROM v$sysmetric_history
   WHERE GROUP_ID=2
   AND metric_name='CPU Usage Per Sec') sysmetric_history
WHERE ash.sample_time (+)=sysmetric_history.sample_time
ORDER BY sample_time;
