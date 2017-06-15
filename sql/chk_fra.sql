ttitle "Free Space in FRA"
col name format a40
set linesize 120 pages 100
select name, space_used/power(1024,2) used_mb, space_limit/power(1024,2) limit_mb, SPACE_USED/SPACE_LIMIT * 100 pct_used from v$recovery_file_dest where name is not null;

