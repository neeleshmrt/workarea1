set linesize 200 pagesize 2000
col owner for a30
col  table_name for a30
col column_name for a30
select owner,table_name,LAST_ANALYZED , column_name, num_distinct, histogram from dba_tab_col_statistics where table_name = '&TableName';
