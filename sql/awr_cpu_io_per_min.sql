select dbid from v$database;
Def v_days=&No_of_days   -- amount of days to cover in report
Def v_secs=60 -- size of bucket in seconds, ie one row represents avg over this interval
Def v_bars=5    -- size of one AAS in characters wide
Def v_graph=80  -- width of graph in characters

undef DBID
set linesize 200 pagesize 2000
col graph format a&v_graph
col aas format 999.9
col total format 99999
col npts format 99999
col wait for 999.9
col cpu for 999.9
col io for 999.9

/* dba_hist_active_sess_history */

select
        to_char(to_date(tday||' '||tmod*&v_secs,'YYMMDD SSSSS'),'DD-MON  HH24:MI:SS') tm,
        --samples npts,
        round(total/&v_secs,1) aas,
        round(cpu/&v_secs,1) cpu,
        round(io/&v_secs,1) io,
        round(waits/&v_secs,1) wait,
	-- substr, ie trunc, the whole graph to make sure it doesn't overflow
        substr(
	   -- substr, ie trunc, the graph below the # of CPU cores line
           -- draw the whole graph and trunc at # of cores line
	   substr(
	     rpad('+',round((cpu*&v_bars)/&v_secs),'+') ||
             rpad('o',round((io*&v_bars)/&v_secs),'o')  ||
             rpad('-',round((waits*&v_bars)/&v_secs),'-')  ||
             rpad(' ',p.value * &v_bars,' '),0,(p.value * &v_bars)) ||
        p.value  ||
	   -- draw the whole graph, then cut off the amount we drew before the # of cores
           substr(
	     rpad('+',round((cpu*&v_bars)/&v_secs),'+') ||
             rpad('o',round((io*&v_bars)/&v_secs),'o')  ||
             rpad('-',round((waits*&v_bars)/&v_secs),'-')  ||
             rpad(' ',p.value * &v_bars,' '),(p.value * &v_bars),( &v_graph-&v_bars*p.value) )
        ,0,&v_graph)
        graph
from (
   select
       to_char(sample_time,'YYMMDD')                   tday
     , trunc(to_char(sample_time,'SSSSS')/&v_secs) tmod
     , (max(sample_id) - min(sample_id) + 1 )      samples
     , sum(decode(session_state,'ON CPU',10,decode(session_type,'BACKGROUND',0,10)))  total
     , sum(decode(session_state,'ON CPU' ,10,0))    cpu
     , sum(decode(session_state,'WAITING',10,0)) -
       sum(decode(session_type,'BACKGROUND',decode(session_state,'WAITING',10,0)))    -
       sum(decode(event,'db file sequential read',10,
                        'db file scattered read',10,
                        'db file parallel read',10,
                        'direct path read',10,
                        'direct path read temp',10,
                        'direct path write',10,
                        'direct path write temp',10, 0)) waits
     , sum(decode(session_type,'FOREGROUND',
		 decode(event,'db file sequential read',10,
                                  'db file scattered read',10,
                                  'db file parallel read',10,
                                  'direct path read',10,
                                  'direct path read temp',10,
                                  'direct path write',10,
                                  'direct path write temp',10, 0))) IO
       /* for waits I want to subtract out the BACKGROUND
          but for CPU I want to count everyone */
   from
      dba_hist_active_sess_history
   where sample_time > sysdate - &v_days
   and dbid=&&DBID
   and sample_time < (select min(sample_time) from v$active_session_history)
   group by  trunc(to_char(sample_time,'SSSSS')/&v_secs),
             to_char(sample_time,'YYMMDD')
) ash,
  ( select  value from dba_hist_parameter where DBID=&&DBID and parameter_name='cpu_count' and rownum < 2 ) p
order by to_date(tday||' '||tmod*&v_secs,'YYMMDD SSSSS')
/
