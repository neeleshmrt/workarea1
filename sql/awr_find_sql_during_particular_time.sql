select  SAMPLE_TIME,SESSION_ID,USERname,SQL_ID,EVENT,P1, P1TEXT,WAIT_CLASS,SESSION_STATE,TIME_WAITED,PROGRAM  from  
dba_hist_active_sess_history a ,dba_users b  where a.user_id=b.user_id and SAMPLE_TIME  between  '27-APR-16 03:00:00.000 PM' and '27-APR-16 03:10:00.000 PM' order by 1;

