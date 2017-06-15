
set lines 1200
set pages 20000

--

REM overview of PGA usage

col name format a40 head "Name"
col value format 999,999,999 head "Total"
col unit format a10 head "Units"
col pga_size format a25 head "PGA Size"
col optimal_executions format 999,999,999,999 head "Optimal"
col onepass_executions format 999,999,999,999 head "One-Pass"
col multipasses_executions format 999,999,999,999 head "Multi-Pass"
col optimal_count format 999,999,999,999 head "Optimal Count"
col optimal_perc format 999 head "Optimal|PCT"
col onepass_count format 999,999,999,999 head "One-Pass Count"
col onepass_perc format 999 head "One|PCT"
col multipass_count format 999,999,999,999 head "Multi-Pass Count"
col multipass_perc format 999 head "Multi|PCT"

col sid format 999,999 Head "SID"
col operation format a30 head "Operation"
col esize format 999,999,999 head "Expected Size"
col mem format 999,999,999 head "Actual Mem"
col "MAX MEM" format 999,999,999 head "Maximum Mem"
col pass format 999,999 head "Passes"
col tsize format 999,999,999,999,999 head "Temporary|Segment Size"

spool workareaoverview.out

SELECT  name,  decode(unit, 'bytes', trunc(value/1024/1024), value) value , 
decode(unit, 'bytes', 'MBytes', unit) unit FROM V$PGASTAT
/

REM Review workarea buckets to see how efficient memory is utilized
REM  Ideal to see OPTIMAL EXECUTIONS vs. ONE-PASS and Multi-PASS

 
select case when low_optimal_size < 1024*1024 
then to_char(low_optimal_size/1024,'999999') || 'kb <= PGA < ' || 
(HIGH_OPTIMAL_SIZE+1)/1024|| 'kb' 
else to_char(low_optimal_size/1024/1024,'999999') || 'mb <= PGA < ' || 
(high_optimal_size+1)/1024/1024|| 'mb' 
end pga_size, 
optimal_executions, 
onepass_executions, 
multipasses_executions 
from v$sql_workarea_histogram where total_executions <> 0 
order by low_optimal_size
/

REM Review workarea buckets as percentages overall
REM      this script assuming 64K optimal size 

SELECT optimal_count, round(optimal_count*100/total, 2) optimal_perc,
       onepass_count, round(onepass_count*100/total, 2) onepass_perc,
       multipass_count, round(multipass_count*100/total, 2) multipass_perc
FROM
       (SELECT decode(sum(total_executions), 0, 1, sum(total_executions)) total,
               sum(OPTIMAL_EXECUTIONS) optimal_count,
               sum(ONEPASS_EXECUTIONS) onepass_count,
               sum(MULTIPASSES_EXECUTIONS) multipass_count
        FROM   v$sql_workarea_histogram
        WHERE  low_optimal_size > 64*1024)
/

REM   Review current activity in Work Areas


SELECT to_number(decode(SID, 65535, NULL, SID)) sid,
       operation_type OPERATION,trunc(EXPECTED_SIZE/1024) ESIZE,
       trunc(ACTUAL_MEM_USED/1024) MEM, trunc(MAX_MEM_USED/1024) "MAX MEM",
       NUMBER_PASSES PASS, trunc(TEMPSEG_SIZE/1024) TSIZE
FROM V$SQL_WORKAREA_ACTIVE
ORDER BY 1,2
/

