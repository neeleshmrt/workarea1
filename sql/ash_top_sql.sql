Select activity_pct , dbtime,  sql_id 
From (
Select round (100 * ratio_to_report(count (*)) over () , 1) as activity_pct,
             Count (*) as dbtime, 
              Sql_id 
From v$active_session_history
Where sample_time between to_timestamp  ('&starttime','yyyy-mm-dd hh24:mi:ss') and to_timestamp  ('&endtime','yyyy-mm-dd hh24:mi:ss') and
Sql_id is not null group by sql_id 
Order by count (*) desc
  ) where rownum < 100;

