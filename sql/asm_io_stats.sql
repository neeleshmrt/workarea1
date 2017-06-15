--V$ASM_DISK_IOSTAT displays information about disk I/O statistics for each ASM client. 
--If V$ASM_DISK_IOSTAT is queried from a database instance, only the rows relating to that instance are shown. 
--ASMCMD lsdsk --statistics shows just the disk statistics. 
--ASMCMD iostat shows a subset of the statistics depending on the option.

SELECT INSTNAME, G.NAME DISKGROUP, SUM(READS) READS,
 SUM(BYTES_READ) BYTES_READ, SUM(WRITES) WRITES,
 SUM(BYTES_WRITTEN) BYTES_WRITTEN
 FROM V$ASM_DISK_IOSTAT I, V$ASM_DISKGROUP G
 WHERE I.GROUP_NUMBER = G.GROUP_NUMBER
 GROUP BY INSTNAME, G.NAME;

SELECT SUM(READ_ERRS)+SUM(WRITE_ERRS) ERRORS FROM V$ASM_DISK;

select inst_id,function_name,
sum(small_read_megabytes+large_read_megabytes) as read_mb,
sum(small_write_megabytes+large_write_megabytes) as write_mb
from gv$iostat_function
group by cube (inst_id,function_name) 
order by inst_id,function_name;
