set linesize 200 pagesize 2000
Select   Case Metric_name
               When 'SQL Service Response Time'
                  Then 'SQL Service Response Time (secs)'
               When 'Response Time Per Txn'
                  Then 'Response Time Per Txn (secs)'
               Else Metric_name
            End Metric_name,
            Case Metric_name
               When 'SQL Service Response Time'
                  Then Round ((Minval / 100), 2)
               When 'Response Time Per Txn'
                  Then Round ((Minval / 100), 2)
               Else Minval
            End Mininum,
            Case Metric_name
               When 'SQL Service Response Time'
                  Then Round ((Maxval / 100), 2)
               When 'Response Time Per Txn'
                  Then Round ((Maxval / 100), 2)
               Else Maxval
            End Maximum,
            Case Metric_name
               When 'SQL Service Response Time'
                  Then Round ((Average / 100), 2)
               When 'Response Time Per Txn'
                  Then Round ((Average / 100), 2)
               Else Average
            End Average
       From Sys.V_$sysmetric_summary
      Where Metric_name In
               ('CPU Usage Per Sec', 'CPU Usage Per Txn',
                'Database CPU Time Ratio', 'Database Wait Time Ratio',
                'Executions Per Sec', 'Executions Per Txn',
                'Response Time Per Txn', 'SQL Service Response Time',
                'User Transaction Per Sec')
   Order By 1;
