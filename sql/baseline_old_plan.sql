BEGIN
  DBMS_SQLTUNE.DROP_SQLSET(
    sqlset_name => 'SQLTUNINGSET1');
END;
/

BEGIN
  DBMS_SQLTUNE.CREATE_SQLSET(
     sqlset_name => 'SQLTUNINGSET1',
     description => 'sqlset descriptions');
END;
/



declare
baseline_ref_cur DBMS_SQLTUNE.SQLSET_CURSOR;
begin
open baseline_ref_cur for
select VALUE(p) from table(
DBMS_SQLTUNE.SELECT_WORKLOAD_REPOSITORY(&begin_snap_id, &end_snap_id,'sql_id='||CHR(39)||'&sql_id'||CHR(39)||' and plan_hash_value=&plan_hash_value',NULL,NULL,NULL,NULL,NULL,NULL,'ALL')) p;
DBMS_SQLTUNE.LOAD_SQLSET('SQLTUNINGSET1', baseline_ref_cur);
end;
/



SELECT
  sql_plan                ,
  plan_hash_value          ,
  sql_id
   FROM TABLE(DBMS_SQLTUNE.SELECT_SQLSET(sqlset_name => 'SQLTUNINGSET1')
             );




set serveroutput on
declare   
plans_loaded pls_integer;
begin   
plans_loaded := sys.dbms_spm.load_plans_from_sqlset(               
sqlset_name => 'SQLTUNINGSET1');   
sys.dbms_output.put_line('Good Plans Loaded : '||plans_loaded);
end;
/


select sql_handle, plan_name,enabled, created ,fixed  from dba_sql_plan_baselines where created > sysdate-1 order by created asc;


set serveroutput on
DECLARE
  l_plans_altered  PLS_INTEGER;
BEGIN
  l_plans_altered := DBMS_SPM.alter_sql_plan_baseline(
    sql_handle      => '&sql_handle',  
    plan_name       => '&plan_name',  
    attribute_name  => 'fixed',
    attribute_value => 'YES');
  
  DBMS_OUTPUT.put_line('Plans Altered: ' || l_plans_altered);
END;
/
