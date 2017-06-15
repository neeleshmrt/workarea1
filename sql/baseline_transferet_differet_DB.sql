1) USING Tuning Set 
2) Transfering Baseline 

1)  Steps USING Tuning Set

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



BEGIN
   DBMS_SQLTUNE.CREATE_STGTAB_SQLSET(     table_name => 'SQLTUNINGSET_TABLE1');
   DBMS_SQLTUNE.PACK_STGTAB_SQLSET(  sqlset_name => 'SQLTUNINGSET1' ,sqlset_owner => 'NEESHARMA' ,staging_table_name => 'SQLTUNINGSET_TABLE1'
     ,staging_schema_owner => 'NEESHARMA'
    );
    END;
   /


Export the Table using expdp 
Import in destination useing impdp 


At destination : 

BEGIN
  DBMS_SQLTUNE.CREATE_SQLSET(
     sqlset_name => 'SQLTUNINGSET1',
     description => 'sqlset descriptions');
END;
/

BEGIN                                                  
    DBMS_SQLTUNE.UNPACK_STGTAB_SQLSET(                  
         sqlset_name => 'SQLTUNINGSET1'    
        ,sqlset_owner => 'NEESHARMA'                      
        ,replace => TRUE                                
        ,staging_table_name => 'SQLTUNINGSET_TABLE1' 
        ,staging_schema_owner => 'NEESHARMA'                  
    );                                                  
END;                                                    
/


SELECT
   plan_hash_value          ,
  sql_id                   , 
  sql_text
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



             
 select sql_handle,plan_name,enabled, FIXED,created,sql_text from dba_sql_plan_baselines WHERE  
 created > SYSDATE-1 AND ENABLED = 'YES'
 order by created ;



set serveroutput on
DECLARE
  l_plans_altered  PLS_INTEGER;
BEGIN
  l_plans_altered := DBMS_SPM.alter_sql_plan_baseline(
    sql_handle      => 'SQL_8de9854d4bddd6c4',  
    plan_name       => 'SQL_PLAN_8vuc59p5xvpq4f56ac234',  
    attribute_name  => 'fixed',
    attribute_value => 'YES');
  
  DBMS_OUTPUT.put_line('Plans Altered: ' || l_plans_altered);
END;
/


set serveroutput on
DECLARE
  l_plans_altered  PLS_INTEGER;
BEGIN
  l_plans_altered := DBMS_SPM.alter_sql_plan_baseline(
    sql_handle      => 'SQL_a499e15ec00bf03f',  
    plan_name       => 'SQL_PLAN_a96g1bv00rw1z5d38ef2d',  
    attribute_name  => 'ENABLED',
    attribute_value => 'NO');
  
  DBMS_OUTPUT.put_line('Plans Altered: ' || l_plans_altered);
END;
/

2) Transfering Baseline

.
.Importing and Exporting SQL Plan Baselines
.
1.On the original system, create a staging table using the CREATE_STGTAB_BASELINE procedure:
BEGIN
DBMS_SPM.CREATE_STGTAB_BASELINE(
table_name => .stage1.);
END;
/
2.pack the needed baselines
DECLARE
my_plans number;
BEGIN
my_plans := DBMS_SPM.PACK_STGTAB_BASELINE(
table_name => .stage1.,
enabled => .yes.,
creator => .dba1.);
END;
/
3.Export the staging table stage1 into a flat file using the export command or Oracle Data Pump.
4.Transfer the flat file to the target system.
5.Import the staging table stage1 from the flat file using the import command or Oracle Data Pump.
6.Unpack the SQL plan baselines from the staging table into the SQL management base on the target system using the UNPACK_STGTAB_BASELINE function:
DECLARE
my_plans number;
BEGIN
my_plans := DBMS_SPM.UNPACK_STGTAB_BASELINE(
table_name => .stage1.,
fixed => .yes.);
END;
/
