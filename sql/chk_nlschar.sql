set lines 200 
set pages 20000
col PARAMETER  for a35
col VALUE  for a30
 SELECT value$ FROM sys.props$ WHERE name = 'NLS_CHARACTERSET' ;
SELECT * FROM NLS_DATABASE_PARAMETERS ;

