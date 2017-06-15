set long 5000
set linesize 200
set longchunksize 1500
spool user_password.sql

select 'alter user '||username||' identified by values '||REGEXP_SUBSTR(DBMS_METADATA.get_ddl ('USER',USERNAME), '''[^'']+''')||';' from dba_users ;
spool off


