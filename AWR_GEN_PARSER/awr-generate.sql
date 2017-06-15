REM Temporary script created by awr-generator.sql
REM Used to create multiple AWR reports between two snapshots

REM Created by user NEESHARMA on ukwhqaorc003a.markit.partners at 26-JUL-2016 13:42
prompt Beginning AWR Generation...
set heading off feedback off lines 800 pages 5000 trimspool on trimout on
prompt Creating AWR Report awrrpt_1_165212_165213.txt  for instance number 1 snapshots 165212 to 165213
prompt
set termout off
spool awrrpt_1_165212_165213.txt
select output from table(dbms_workload_repository.awr_report_text(4255406167,1,165212,165213,0));
spool off
set termout on
prompt Creating AWR Report awrrpt_1_165213_165214.txt  for instance number 1 snapshots 165213 to 165214
prompt
set termout off
spool awrrpt_1_165213_165214.txt
select output from table(dbms_workload_repository.awr_report_text(4255406167,1,165213,165214,0));
spool off
set termout on
prompt Creating AWR Report awrrpt_1_165214_165215.txt  for instance number 1 snapshots 165214 to 165215
prompt
set termout off
spool awrrpt_1_165214_165215.txt
select output from table(dbms_workload_repository.awr_report_text(4255406167,1,165214,165215,0));
spool off
set termout on
prompt Creating AWR Report awrrpt_1_165215_165216.txt  for instance number 1 snapshots 165215 to 165216
prompt
set termout off
spool awrrpt_1_165215_165216.txt
select output from table(dbms_workload_repository.awr_report_text(4255406167,1,165215,165216,0));
spool off
set termout on
prompt Creating AWR Report awrrpt_2_165212_165213.txt  for instance number 2 snapshots 165212 to 165213
prompt
set termout off
spool awrrpt_2_165212_165213.txt
select output from table(dbms_workload_repository.awr_report_text(4255406167,2,165212,165213,0));
spool off
set termout on
prompt Creating AWR Report awrrpt_2_165213_165214.txt  for instance number 2 snapshots 165213 to 165214
prompt
set termout off
spool awrrpt_2_165213_165214.txt
select output from table(dbms_workload_repository.awr_report_text(4255406167,2,165213,165214,0));
spool off
set termout on
prompt Creating AWR Report awrrpt_2_165214_165215.txt  for instance number 2 snapshots 165214 to 165215
prompt
set termout off
spool awrrpt_2_165214_165215.txt
select output from table(dbms_workload_repository.awr_report_text(4255406167,2,165214,165215,0));
spool off
set termout on
prompt Creating AWR Report awrrpt_2_165215_165216.txt  for instance number 2 snapshots 165215 to 165216
prompt
set termout off
spool awrrpt_2_165215_165216.txt
select output from table(dbms_workload_repository.awr_report_text(4255406167,2,165215,165216,0));
spool off
set termout on
prompt Creating AWR Report awrrpt_3_165212_165213.txt  for instance number 3 snapshots 165212 to 165213
prompt
set termout off
spool awrrpt_3_165212_165213.txt
select output from table(dbms_workload_repository.awr_report_text(4255406167,3,165212,165213,0));
spool off
set termout on
prompt Creating AWR Report awrrpt_3_165213_165214.txt  for instance number 3 snapshots 165213 to 165214
prompt
set termout off
spool awrrpt_3_165213_165214.txt
select output from table(dbms_workload_repository.awr_report_text(4255406167,3,165213,165214,0));
spool off
set termout on
prompt Creating AWR Report awrrpt_3_165214_165215.txt  for instance number 3 snapshots 165214 to 165215
prompt
set termout off
spool awrrpt_3_165214_165215.txt
select output from table(dbms_workload_repository.awr_report_text(4255406167,3,165214,165215,0));
spool off
set termout on
prompt Creating AWR Report awrrpt_3_165215_165216.txt  for instance number 3 snapshots 165215 to 165216
prompt
set termout off
spool awrrpt_3_165215_165216.txt
select output from table(dbms_workload_repository.awr_report_text(4255406167,3,165215,165216,0));
spool off
set termout on
prompt Creating AWR Report awrrpt_4_165212_165213.txt  for instance number 4 snapshots 165212 to 165213
prompt
set termout off
spool awrrpt_4_165212_165213.txt
select output from table(dbms_workload_repository.awr_report_text(4255406167,4,165212,165213,0));
spool off
set termout on
prompt Creating AWR Report awrrpt_4_165213_165214.txt  for instance number 4 snapshots 165213 to 165214
prompt
set termout off
spool awrrpt_4_165213_165214.txt
select output from table(dbms_workload_repository.awr_report_text(4255406167,4,165213,165214,0));
spool off
set termout on
prompt Creating AWR Report awrrpt_4_165214_165215.txt  for instance number 4 snapshots 165214 to 165215
prompt
set termout off
spool awrrpt_4_165214_165215.txt
select output from table(dbms_workload_repository.awr_report_text(4255406167,4,165214,165215,0));
spool off
set termout on
prompt Creating AWR Report awrrpt_4_165215_165216.txt  for instance number 4 snapshots 165215 to 165216
prompt
set termout off
spool awrrpt_4_165215_165216.txt
select output from table(dbms_workload_repository.awr_report_text(4255406167,4,165215,165216,0));
spool off
set termout on
set heading on feedback 6 lines 100 pages 45
prompt AWR Generation Complete
