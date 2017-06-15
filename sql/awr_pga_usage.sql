set linesie 200 pagesize 2000


WITH
pgastat_denorm_1 AS (
SELECT /*+ MATERIALIZE NO_MERGE */
       snap_id,
       dbid,
       instance_number,
       SUM(CASE name WHEN 'PGA memory freed back to OS'           THEN value ELSE 0 END) pga_mem_freed_to_os,
       SUM(CASE name WHEN 'aggregate PGA auto target'             THEN value ELSE 0 END) aggr_pga_auto_target,
       SUM(CASE name WHEN 'aggregate PGA target parameter'        THEN value ELSE 0 END) aggr_pga_target_param,
       SUM(CASE name WHEN 'bytes processed'                       THEN value ELSE 0 END) bytes_processed,
       SUM(CASE name WHEN 'extra bytes read/written'              THEN value ELSE 0 END) extra_bytes_rw,
       SUM(CASE name WHEN 'global memory bound'                   THEN value ELSE 0 END) global_memory_bound,
       SUM(CASE name WHEN 'maximum PGA allocated'                 THEN value ELSE 0 END) max_pga_allocated,
       SUM(CASE name WHEN 'maximum PGA used for auto workareas'   THEN value ELSE 0 END) max_pga_used_aut_wa,
       SUM(CASE name WHEN 'maximum PGA used for manual workareas' THEN value ELSE 0 END) max_pga_used_man_wa,
       SUM(CASE name WHEN 'total PGA allocated'                   THEN value ELSE 0 END) tot_pga_allocated,
       SUM(CASE name WHEN 'total PGA inuse'                       THEN value ELSE 0 END) tot_pga_inuse,
       SUM(CASE name WHEN 'total PGA used for auto workareas'     THEN value ELSE 0 END) tot_pga_used_aut_wa,
       SUM(CASE name WHEN 'total PGA used for manual workareas'   THEN value ELSE 0 END) tot_pga_used_man_wa,
       SUM(CASE name WHEN 'total freeable PGA memory'             THEN value ELSE 0 END) tot_freeable_pga_mem
  FROM dba_hist_pgastat
 WHERE name IN
('PGA memory freed back to OS'
,'aggregate PGA auto target'
,'aggregate PGA target parameter'
,'bytes processed'
,'extra bytes read/written'
,'global memory bound'
,'maximum PGA allocated'
,'maximum PGA used for auto workareas'
,'maximum PGA used for manual workareas'
,'total PGA allocated'
,'total PGA inuse'
,'total PGA used for auto workareas'
,'total PGA used for manual workareas'
,'total freeable PGA memory'
)
   AND snap_id in (select snap_id from dba_hist_snapshot where begin_interval_time > sysdate -60)
 GROUP BY
       snap_id,
       dbid,
       instance_number
),
pgastat_denorm_2 AS (
SELECT /*+ MATERIALIZE NO_MERGE */
       h.dbid,
       h.instance_number,
       s.startup_time,
       MIN(h.pga_mem_freed_to_os) pga_mem_freed_to_os,
       MIN(h.bytes_processed) bytes_processed,
       MIN(h.extra_bytes_rw) extra_bytes_rw
  FROM pgastat_denorm_1 h,
       dba_hist_snapshot s
 WHERE s.snap_id = h.snap_id
   AND s.dbid = h.dbid
   AND s.instance_number = h.instance_number
 GROUP BY
       h.dbid,
       h.instance_number,
       s.startup_time
),
pgastat_delta AS (
SELECT /*+ MATERIALIZE NO_MERGE */
       h1.snap_id,
       h1.dbid,
       h1.instance_number,
       s1.begin_interval_time,
       s1.end_interval_time,
       ROUND((CAST(s1.end_interval_time AS DATE) - CAST(s1.begin_interval_time AS DATE)) * 24 * 60 * 60) interval_secs,
       (h1.pga_mem_freed_to_os - h0.pga_mem_freed_to_os) pga_mem_freed_to_os,
       h1.aggr_pga_auto_target,
       h1.aggr_pga_target_param,
       (h1.bytes_processed - h0.bytes_processed) bytes_processed,
       (h1.extra_bytes_rw - h0.extra_bytes_rw) extra_bytes_rw,
       h1.global_memory_bound,
       h1.max_pga_allocated,
       h1.max_pga_used_aut_wa,
       h1.max_pga_used_man_wa,
       h1.tot_pga_allocated,
       h1.tot_pga_inuse,
       h1.tot_pga_used_aut_wa,
       h1.tot_pga_used_man_wa,
       h1.tot_freeable_pga_mem
  FROM pgastat_denorm_1 h0,
       pgastat_denorm_1 h1,
       dba_hist_snapshot s0,
       dba_hist_snapshot s1,
       pgastat_denorm_2 min /* to see cumulative use (replace h0 with min on select list above) */
 WHERE h1.snap_id = h0.snap_id + 1
   AND h1.dbid = h0.dbid
   AND h1.instance_number = h0.instance_number
   AND s0.snap_id = h0.snap_id
   AND s0.dbid = h0.dbid
   AND s0.instance_number = h0.instance_number
   AND s1.snap_id = h1.snap_id
   AND s1.dbid = h1.dbid
   AND s1.instance_number = h1.instance_number
   AND s1.snap_id = s0.snap_id + 1
   AND s1.startup_time = s0.startup_time
   AND s1.begin_interval_time > (s0.begin_interval_time + (1 / (24 * 60))) /* filter out snaps apart < 1 min */
   AND min.dbid = s1.dbid
   AND min.instance_number = s1.instance_number
   AND min.startup_time = s1.startup_time
)
SELECT snap_id,
       TO_CHAR(MIN(begin_interval_time), 'YYYY-MM-DD HH24:MI') begin_time,
       TO_CHAR(MIN(end_interval_time), 'YYYY-MM-DD HH24:MI') end_time,
       ROUND(SUM(pga_mem_freed_to_os) / POWER(2, 30), 3) pga_mem_freed_to_os,
       ROUND(SUM(aggr_pga_auto_target) / POWER(2, 30), 3) aggr_pga_auto_target,
       ROUND(SUM(aggr_pga_target_param) / POWER(2, 30), 3) aggr_pga_target_param,
       ROUND(SUM(bytes_processed) / POWER(2, 30), 3) bytes_processed,
       ROUND(SUM(extra_bytes_rw) / POWER(2, 30), 3) extra_bytes_rw,
       ROUND(SUM(global_memory_bound) / POWER(2, 30), 3) global_memory_bound,
       ROUND(SUM(max_pga_allocated) / POWER(2, 30), 3) max_pga_allocated,
       ROUND(SUM(max_pga_used_aut_wa) / POWER(2, 30), 3) max_pga_used_aut_wa,
       ROUND(SUM(max_pga_used_man_wa) / POWER(2, 30), 3) max_pga_used_man_wa,
       ROUND(SUM(tot_pga_allocated) / POWER(2, 30), 3) tot_pga_allocated,
       ROUND(SUM(tot_pga_inuse) / POWER(2, 30), 3) tot_pga_inuse,
       ROUND(SUM(tot_pga_used_aut_wa) / POWER(2, 30), 3) tot_pga_used_aut_wa,
       ROUND(SUM(tot_pga_used_man_wa) / POWER(2, 30), 3) tot_pga_used_man_wa,
       ROUND(SUM(tot_freeable_pga_mem) / POWER(2, 30), 3) tot_freeable_pga_mem,
       0 dummy_15
  FROM pgastat_delta
 GROUP BY
       snap_id
 ORDER BY
       snap_id;
