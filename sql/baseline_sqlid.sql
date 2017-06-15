SQL_ID: 7rb2n6f3zyxaj 
PHV: 3789046929 

-- CREATE SQLSET 
EXEC DBMS_SQLTUNE.CREATE_SQLSET('SQLID_'||'&sqlid'); 
-- LOAD SQLSET 
DECLARE 
   BASELINE_REF_CURSOR DBMS_SQLTUNE.SQLSET_CURSOR; 
BEGIN 
   OPEN BASELINE_REF_CURSOR FOR 
   SELECT VALUE(p) FROM TABLE(DBMS_SQLTUNE.SELECT_WORKLOAD_REPOSITORY(118868,119733,'sql_id='||CHR(39)||'&sqlid'||CHR(39)||' and plan_hash_value=&phv',NULL,NULL,NULL,NULL,NULL,NULL,'ALL')) p; 
   DBMS_SQLTUNE.LOAD_SQLSET('SQLID_'||'&sqlid',BASELINE_REF_CURSOR); 
END; 
/ 


set serveroutput on
declare   
plans_loaded pls_integer;
begin   
plans_loaded := sys.dbms_spm.load_plans_from_sqlset(               
sqlset_name => 'SQLID_&sqlid');   
sys.dbms_output.put_line('Good Plans Loaded : '||plans_loaded);
end;
/


set serveroutput on
DECLARE
  l_plans_altered  PLS_INTEGER;
BEGIN
  l_plans_altered := DBMS_SPM.alter_sql_plan_baseline(
    sql_handle      => 'SQL_b13199118d00c746',  
    plan_name       => 'SQL_PLAN_b2cct266h1ju62b8272f1',  
    attribute_name  => 'fixed',
    attribute_value => 'YES');
  
  DBMS_OUTPUT.put_line('Plans Altered: ' || l_plans_altered);
END;
/


-- LOAD PLAN FROM SQLSET 
DECLARE 
   my_integer pls_integer; 
BEGIN 
  my_integer := dbms_spm.load_plans_from_sqlset ( 
  sqlset_name => 'SQLID_'||'&sqlid', 
  sqlset_owner => 'SYS', 
  basic_filter => 'sql_id='''||'&sqlid'||'''', 
  fixed => 'YES', 
  enabled => 'YES'); 
  DBMS_OUTPUT.PUT_line('Loaded Plan(s) From SQL Set: '||my_integer); 
END; 
/ 
-- PURGE CURSOR (On 2nd instance) 
DECLARE 
   v_inst_id NUMBER; 
   CURSOR purge IS 
      SELECT inst_id,address,hash_value FROM GV$SQLAREA WHERE SQL_ID='&sqlid'; 
BEGIN 
   SELECT instance_number INTO v_inst_id FROM v$instance; 
   FOR x IN purge LOOP 
      EXIT WHEN purge%NOTFOUND; 
      IF x.inst_id = v_inst_id THEN 
         DBMS_OUTPUT.PUT_LINE('Purging Cursor: '||x.address||','||x.hash_value||' On Instance: '||x.inst_id); 
         DBMS_SHARED_POOL.PURGE(x.address||','||x.hash_value,'C'); 
      ELSE 
         DBMS_OUTPUT.PUT_LINE('Cursor: '||x.address||','||x.hash_value||' On Instance: '||x.inst_id||' can NOT be purged here!'); 
      END IF; 
   END LOOP; 
END; 
/ 
