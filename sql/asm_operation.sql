 TTITLE 'Long-Running ASM Operations (From V$ASM_OPERATIONS)'
COL group_number        FORMAT 99999    HEADING 'ASM|Disk|Grp #'
COL operation           FORMAT A08      HEADING 'ASM|Oper-|ation'
COL state               FORMAT A08      HEADING 'ASM|State'
COL power               FORMAT 999999   HEADING 'ASM|Power|Rqstd'
COL actual              FORMAT 99999999999999   HEADING 'ASM|Power|Alloc'
COL est_work            FORMAT 99999999999999   HEADING 'AUs|To Be|Moved'
COL sofar               FORMAT 99999999999999   HEADING 'AUs|Moved|So Far'
COL est_rate            FORMAT 99999999999999   HEADING 'AUs|Moved|PerMI'
COL est_minutes         FORMAT 99999999999999   HEADING 'Est|Time|Until|Done|(Min)'
SELECT
     inst_id
    ,group_number
    ,operation
    ,state
    ,power
    ,actual
    ,est_work
    ,sofar
    ,est_rate
    ,est_minutes
  FROM gv$asm_operation
;

