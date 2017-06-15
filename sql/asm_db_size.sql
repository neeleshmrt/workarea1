REM asm_db_size.sql
REM Author - Jay Caviness - Grumpy-dba.com
REM 5 March 2009
REM ------------------------------------------------------------
set pages 999
set heading on
set feedback off
set lines 80
col "Size in MB" for 999,999,999
col "Database" for a25

select database_name "Database",
         sum(space)/1024/1024/1024 "Size in GB" FROM (
  SELECT
      CONNECT_BY_ROOT db_name as database_name, space
  FROM
      ( SELECT
            a.parent_index       pindex
          , a.name               db_name
          , a.reference_index    rindex
          , f.bytes              bytes
          , f.space              space
          , f.type               type
        FROM
            v$asm_file f RIGHT OUTER JOIN v$asm_alias a  USING (group_number, file_number) 
             JOIN v$asm_diskgroup g USING (group_number) where  g.name='&DG_NAME'
      )
  WHERE type IS NOT NULL
  START WITH (MOD(pindex, POWER(2, 24))) = 0
      CONNECT BY PRIOR rindex = pindex)
group by database_name
order by database_name
/



