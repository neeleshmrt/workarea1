set linesize 200 pagesize 200
col owner for a30
col  segment_name for a40
select owner,segment_name,sum(bytes)/1024/1024/1024  Size_GB  from dba_segments where segment_name=upper('&OBJ_NAME') group by  owner,segment_name;

