export ORACLE_SID=pvlqa1
export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2.1_1.3/racdbhome_1
export PATH=$ORACLE_HOME/bin:$PATH

sqlplus -s /nolog <<EOF
connect / as sysdba
set echo on feed on
whenever sqlerror exit;
set serveroutput on
set timing on time on
alter session enable resumable timeout 14400 name 'GATHER STATITICS TIME CHECKER';
spool pvlqa_gatherstatstask.log
begin
dbms_stats.gather_schema_stats(
ownname=>'CORE',
ESTIMATE_PERCENT=>dbms_stats.auto_sample_size,
METHOD_OPT=>'FOR ALL COLUMNS SIZE AUTO',
GRANULARITY=>'ALL',
CASCADE=>TRUE,
DEGREE=>DBMS_STATS.DEFAULT_DEGREE,
NO_INVALIDATE=>FALSE,
OPTIONS=>'GATHER');
end;
/
spool off
exit;
EOF
