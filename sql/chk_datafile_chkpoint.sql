set linesize 200 pagesize 20000

select FILE#,name ,CREATION_CHANGE#,CREATION_TIME,CHECKPOINT_CHANGE#,CHECKPOINT_TIME from v$datafile  where CHECKPOINT_CHANGE# < &scn order by   FILE#;

