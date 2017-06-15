set linesize 200 pagesize 20000
col name for a70
col Size_GB for 999999999.99
col  MaxSize_GB  for 999999999.99
select dbv.file_name name,dbv.bytes/1024/1024/1024 Size_GB,creation_time,dbv.AUTOEXTENSIBLE AUTOEXTENSIBLE ,dbv.MAXBYTES/1024/1024/1024 MaxSize_GB,dbv.status Status from dba_data_files dbv , v$datafile dv 
 where dbv.file_id=dv.file# and dbv.tablespace_name like '&a' order by creation_time;    

