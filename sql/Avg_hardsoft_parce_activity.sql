set lines 200 pagesi 2000

Select   Case Db_stat_name
               When 'parse time elapsed'
                  Then 'soft parse time'
               Else Db_stat_name
            End Db_stat_name,
            Case Db_stat_name
               When 'sql execute elapsed time'
                  Then Time_secs - Plsql_time
               When 'parse time elapsed'
                  Then Time_secs - Hard_parse_time
               Else Time_secs
            End Time_secs,
            Case Db_stat_name
               When 'sql execute elapsed time'
                  Then Round (100 * (Time_secs - Plsql_time) / Db_time,
                              2
                             )
               When 'parse time elapsed'
                  Then Round (100 * (Time_secs - Hard_parse_time) / Db_time,
                              2)
               Else Round (100 * Time_secs / Db_time, 2)
            End Pct_time
       From (Select Stat_name Db_stat_name,
                    Round ((Value / 1000000), 3) Time_secs
               From Sys.V_$sys_time_model
              Where Stat_name Not In
                       ('DB time', 'background elapsed time',
                        'background cpu time', 'DB CPU')),
            (Select Round ((Value / 1000000), 3) Db_time
               From Sys.V_$sys_time_model
              Where Stat_name = 'DB time'),
            (Select Round ((Value / 1000000), 3) Plsql_time
               From Sys.V_$sys_time_model
              Where Stat_name = 'PL/SQL execution elapsed time'),
            (Select Round ((Value / 1000000), 3) Hard_parse_time
               From Sys.V_$sys_time_model
              Where Stat_name = 'hard parse elapsed time')
   Order By 2 Desc;
