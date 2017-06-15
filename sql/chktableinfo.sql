accept owner      prompt 'Enter table owner: '
accept table_name prompt 'Enter table name: '
REM
REM Table Definition
REM
describe &owner..&table_name

REM
REM Table and Indexes Info .....
REM
set wrap off linesize 200 pages 200 numf 99999999999999999999999999999999999999
col COLUMN_NAME                 for a20
col TABLE_NAME                  for a25
col TABLESPACE_NAME             for a15
col Table                       for a25
col type                        for a8
col Ind                         for a25
col Col                         for a15
col Pos                         for 990
col Tbs                         for a20
col unq                         for a3
col deg                         for a8
col NUM_ROWS                    for 9999999999
col degree                      for 9999
col SAMPLE_SIZE                 for 9999999999
col CLUSTERING_FACTOR for 9999999999 


select  t.table_name "Table" ,decode(t.index_type,'NORMAL','BTree','BITMAP','Bitmap','FUNCTION-BASED NORMAL','Function-Based BTree',t.index_type) "Type" ,t.status ,t.index_name "Ind" ,c.column_name "Col" ,c.column_position "Pos" ,decode(t.uniqueness,'UNIQUE','UNQ',NULL) "unq" ,
t.partitioned "Prt" ,t.degree "deg" ,t.NUM_ROWS NUM_ROWS ,SAMPLE_SIZE,t.CLUSTERING_FACTOR,t.TABLESPACE_NAME,t.LAST_ANALYZED
from dba_indexes t , dba_ind_columns c
where t.table_name   = c.table_name
and   t.index_name   = c.index_name
and t.owner          = upper('&owner')
and t.table_name     = upper('&table_name')
and t.index_type not in ('IOT - TOP','LOB')
order by t.table_name, t.index_name, c.column_position;
/

REM
REM Column Definitions
REM
select column_name, num_distinct, num_nulls, num_buckets, density, sample_size from dba_tab_columns
WHERE upper(owner)    = upper('&owner')
AND upper(table_name) = upper('&table_name')
order by column_name
/


REM
REM Existing Histograms
REM
SELECT column_name, endpoint_number, endpoint_value FROM dba_histograms
WHERE upper(table_name) = upper('&table_name')
AND   upper(owner)      = upper('&owner')
ORDER BY column_name, endpoint_number
/


REM
REM Row Counts
REM
SELECT table_name, num_rows, degree, last_analyzed FROM dba_tables
WHERE upper(owner)    = upper('&owner')
AND upper(table_name) = upper('&table_name')
/

REM
REM Table and Indexes - Segment Sizes
REM
column segment_name format a50
SELECT segment_name, segment_type, SUM(bytes)/1024/1024 size_mb FROM dba_segments
WHERE upper(owner)      = upper('&owner')
AND upper(segment_name) = upper('&table_name')
OR segment_name in (select index_name from dba_indexes
                    where upper(table_name) = upper('&table_name')
                    and upper(table_owner)  = upper('&owner'))
GROUP BY segment_name, segment_type
/

REM uncomment this line if you want "live" row counts
REM  - for large tables this could run for a while and cause performance problems
REM
REM select count(*) from "&owner"."&table_name"
REM /
