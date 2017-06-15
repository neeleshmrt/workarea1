
DECLARE
  l_sql_tune_task_id  VARCHAR2(100);
BEGIN
  l_sql_tune_task_id := DBMS_SQLTUNE.create_tuning_task (
                          sql_id      => '&&SQL_ID',
                          scope       => DBMS_SQLTUNE.scope_comprehensive,
                          time_limit  => 300,
                          task_name   => 'Tuning_task_&&SQL_ID',
                          description => 'Tuning task for statement &&SQL_ID.');
  DBMS_OUTPUT.put_line('l_sql_tune_task_id: ' || l_sql_tune_task_id);
END;
/


EXEC DBMS_SQLTUNE.execute_tuning_task(task_name => 'Tuning_task_&&SQL_ID');


SET LONG 100000;
SET LONGCHUNKSIZE 10000;
SET PAGESIZE 1000
SET LINESIZE 500
SELECT DBMS_SQLTUNE.report_tuning_task('Tuning_task_&&SQL_ID') AS recommendations FROM dual;
SET PAGESIZE 30
SET LONG 10000
SET LONGCHUNKSIZE 1000
undef SQL_ID


exec  DBMS_SQLTUNE.drop_tuning_task (task_name => 'Tuning_task_&&SQL_ID'); 
