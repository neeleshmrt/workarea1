set linesize 200 
set pagesize 200
col Free_GB for 9999999999999.99
col Total_GB for 9999999999999.99

select A.NAME,B.NAME,b.DISK_NUMBER,b.STATE,b.TOTAL_MB/1024 Total_GB,b.FREE_MB/1024 Free_GB  FROM V$ASM_DISKGROUP A,V$ASM_DISK B WHERE A.GROUP_NUMBER=B.GROUP_NUMBER and  A.NAME='&Disk_Name' order by 2;

