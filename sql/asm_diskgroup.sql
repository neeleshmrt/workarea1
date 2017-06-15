set lines 200
set pages 1000
TTITLE 'ASM Disk Groups (From V$ASM_DISKGROUP)'
COL group_number        FORMAT 99999    HEADING 'ASM|Disk|Grp #' 
COL name                FORMAT A12      HEADING 'ASM Disk|Group Name' WRAP
COL sector_size         FORMAT 99999999 HEADING 'Sector|Size'
COL block_size          FORMAT 999999   HEADING 'Block|Size'
COL au_size             FORMAT 99999999 HEADING 'Alloc|Unit|Size'
COL state               FORMAT A11      HEADING 'Disk|Group|State'
COL type                FORMAT A06      HEADING 'Disk|Group|Type'
COL total_mb            FORMAT 99999999   HEADING 'Total|Space(MB)'
COL free_mb             FORMAT 99999999   HEADING 'Free|Space(MB)'
SELECT 
     group_number
    ,name
    ,sector_size
    ,block_size
    ,allocation_unit_size au_size
    ,state
    ,type
    ,total_mb
    ,free_mb
  FROM v$asm_diskgroup
;
