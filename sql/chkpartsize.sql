set linesize 200 pagesize 200
col owner for a30
col  segment_name for a40
col PARTITION_NAME for a40

select owner,segment_name,PARTITION_NAME,sum(bytes)/1024/1024/1024  Size_GB  from dba_segments where segment_name='&OBJ_NAME' and PARTITION_NAME='&PARTITION_NAME' group by  owner,segment_name,PARTITION_NAME;

