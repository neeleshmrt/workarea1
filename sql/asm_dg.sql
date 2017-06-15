set lines 200
set pagesize 2000
col DG_NAME  format a15
col Disk_Name format a25
col path        format a40 
break on group_number
select  
a.group_number ,b.name DG_Name ,a.TOTAL_MB TOTAL_GB,a.FREE_MB/1024  FREE_GB 
,       a.disk_number
,       a.mount_status
,       a.state
,a.name Disk_Name
,       a.path
from    v$asm_disk a ,  v$asm_diskgroup b
where a.GROUP_NUMBER=b.GROUP_NUMBER
order   by group_number,Disk_Name
/
