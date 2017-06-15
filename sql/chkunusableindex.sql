set linesize 200 pagesize 2000

--Normal Index 
COLUMN index_owner          HEADING "Owner" FORMAT A8
COLUMN INDEX_NAME    HEADING "Index Name" FORMAT A30
COLUMN PARTITION_NAME    HEADING "Partition Type" FORMAT A50
COLUMN status         HEADING "Status"

select index_owner,INDEX_NAME,PARTITION_NAME,STATUS from dba_ind_partitions where status <> 'USABLE';

select 'alter index '||owner||'.'||index_name||' rebuild online parallel 4;' from dba_indexes where status='UNUSABLE'; 
select 'alter index '||owner||'.'||index_name||' noparallel;' from dba_indexes where status='UNUSABLE' ; 


-- Parttion Index 
 select index_owner,INDEX_NAME,PARTITION_NAME,SUBPARTITION_COUNT,STATUS from dba_ind_partitions where status='UNUSABLE';

select 'alter index '||owner||'.'||index_name||' REBUILD PARTITION '||PARTITION_NAME||'  online parallel 4; '  from dba_ind_partitions where status='UNUSABLE';
select 'alter index '||owner||'.'||index_name||'noparallel;'  from dba_ind_partitions where status='UNUSABLE';



