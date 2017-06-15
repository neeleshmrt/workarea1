Procedure
Verify that you have good results with the plan you want to use! 

Obtain the SQL_ID and PLAN_HASH_VALUE for the good plan

 
Create a plan baseline for the bad statement (you need a SQL Handle for this statement) 

If the SQL is in the Cursor Cache:
 
set serveroutput on
 
declare
    plans_loaded pls_integer;
begin
    plans_loaded := sys.dbms_spm.load_plans_from_cursor_cache('bad_id');
    sys.dbms_output.put_line('Plans Loaded for bad_id : '||plans_loaded);
end;
/
 
 
 
 
OR if the SQL is from the AWR:
BEGIN  
DBMS_SQLTUNE.CREATE_SQLSET(    
sqlset_name => '<sql tuning set name>', --choose one    
description  => '<description>); -- choose one
END; /
  
DECLARE
  l_cursor  DBMS_SQLTUNE.sqlset_cursor;
BEGIN
  OPEN l_cursor FOR
    SELECT VALUE(p)
    FROM   TABLE (DBMS_SQLTUNE.select_workload_repository (
                    <beginsnap>,  -- begin_snap
                    <endsnap>,  -- end_snap
                    'SQL_ID = ''bad_id''', -- basic_filter
                    NULL, -- object_filter
                    NULL, -- ranking_measure1
                    NULL, -- ranking_measure2
                    NULL, -- ranking_measure3
                    NULL, -- result_percentage
                    10)   -- result_limit
                  ) p;
  DBMS_SQLTUNE.load_sqlset (
    sqlset_name     => '<sql tuning set name>',
    populate_cursor => l_cursor);
END;
/
 
set serveroutput on
declare   
plans_loaded pls_integer;
begin   
plans_loaded := sys.dbms_spm.load_plans_from_sqlset(               
sqlset_name => '&sqlset_name');   
sys.dbms_output.put_line('Good Plans Loaded : '||plans_loaded);
end;
/
Grab the sql handle and record as badhandle 
select sql_handle,sql_text,plan_name,enabled, created from dba_sql_plan_baselines order by created asc;
Disable the baseline(s) you just captured (This can be done in OEM as well)
declare
    plans_disabled number;
begin
    plans_disabled := sys.dbms_spm.alter_sql_plan_baseline(
            sql_handle          => 'bad_handle',
            plan_name           => 'badplanname',
            attribute_name      => 'enabled',
            attribute_value     => 'NO');
end;
/
Associate the good plan with the bad sql handle
 
set serveroutput on
declare
    plans_loaded pls_integer;
begin
    plans_loaded := sys.dbms_spm.load_plans_from_cursor_cache(
                sql_id      => 'good_id'
            ,   plan_hash_value => 'good_phv'
            ,   sql_handle  => 'bad_handle');
    sys.dbms_output.put_line('Good Plans Loaded : '||plans_loaded);
end;
/
Get the good plan name 
 
select sql_handle,sql_text,plan_name,enabled, created from dba_sql_plan_baselines order by created asc;
fix the plan 
set serveroutput on
DECLARE
  l_plans_altered  PLS_INTEGER;
BEGIN
  l_plans_altered := DBMS_SPM.alter_sql_plan_baseline(
    sql_handle      => '&sql_handle', -- new statement
    plan_name       => '&plan_name', -- good plan
    attribute_name  => 'fixed',
    attribute_value => 'YES');
  
  DBMS_OUTPUT.put_line('Plans Altered: ' || l_plans_altered);
END;
/
