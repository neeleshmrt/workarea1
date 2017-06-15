set linesize 200 pagesize 2000
col  HIGHVAL_DUMP for a30
col  HIGH_DATE for a35
col   MIN_DATE for a35
col  LOWVAL_DUMP for a30


select lowval_dump,
        -- extract the century and year information from the
        -- internal date format
        -- century = (century byte -100) * 100
        to_char((
                to_number(
                        -- parse out integer appearing before first comma
                        substr( lowval_dump, 1, instr(lowval_dump,',')-1) - 100
                ) * 100
        )
        +
        -- year = year byte - 100
        (
                to_number(
                        substr(
                                lowval_dump,
                                -- get position of 2nd comma
                                instr(lowval_dump,',',2)+1,
                                -- get position of 2nd comma - position of 1st comma
                                instr(lowval_dump,',',1,2) - instr(lowval_dump,',',1,1) -1
                        )
                )
                - 100
        )) --current_year
         || '-' || substr(
            lowval_dump,
            instr(lowval_dump,',',1,2)+1,
            instr(lowval_dump,',',1,3) - instr(lowval_dump,',',1,2) -1
         ) -- month
         ||  '-' || substr(
            lowval_dump,
            instr(lowval_dump,',',1,3)+1,
            instr(lowval_dump,',',1,4) - instr(lowval_dump,',',1,3) -1
         ) -- day
         || ' ' ||
         lpad(
            to_char(to_number(
               substr(
                  lowval_dump,
                  instr(lowval_dump,',',1,4)+1,
                  instr(lowval_dump,',',1,5) - instr(lowval_dump,',',1,4) -1
               )
            )-1)
            ,2,'0'
         ) -- hour
         || ':' ||
         lpad(
            to_char(
               to_number(
                  substr(
                     lowval_dump,
                     instr(lowval_dump,',',1,5)+1,
                     instr(lowval_dump,',',1,6) - instr(lowval_dump,',',1,5) -1
                  )
               )-1
            )
            ,2,'0'
         ) -- minute
         || ':' ||
         lpad(
            to_char(
               to_number(
                  substr(
                     lowval_dump,
                     instr(lowval_dump,',',1,6)+1
                  )
               )-1
            )
            ,2,'0'
         ) --second
         min_date ,
highval_dump,
        -- extract the century and year information from the
        -- internal date format
        -- century = (century byte -100) * 100
        to_char((
                to_number(
                        -- parse out integer appearing before first comma
                        substr( highval_dump, 1, instr(highval_dump,',')-1) - 100
                ) * 100
        )
        +
        -- year = year byte - 100
        (
                to_number(
                        substr(
                                highval_dump,
                                -- get position of 2nd comma
                                instr(highval_dump,',',2)+1,
                                -- get position of 2nd comma - position of 1st comma
                                instr(highval_dump,',',1,2) - instr(highval_dump,',',1,1) -1
                        )
                )
                - 100
        )) --current_year
         || '-' || substr(
            highval_dump,
            instr(highval_dump,',',1,2)+1,
            instr(highval_dump,',',1,3) - instr(highval_dump,',',1,2) -1
         ) -- month
         ||  '-' || substr(
            highval_dump,
            instr(highval_dump,',',1,3)+1,
            instr(highval_dump,',',1,4) - instr(highval_dump,',',1,3) -1
         ) -- day
         || ' ' ||
         lpad(
            to_char(to_number(
               substr(
                  highval_dump,
                  instr(highval_dump,',',1,4)+1,
                  instr(highval_dump,',',1,5) - instr(highval_dump,',',1,4) -1
               )
            )-1)
            ,2,'0'
         ) -- hour
         || ':' ||
         lpad(
            to_char(
               to_number(
                  substr(
                     highval_dump,
                     instr(highval_dump,',',1,5)+1,
                     instr(highval_dump,',',1,6) - instr(highval_dump,',',1,5) -1
                  )
               )-1
            )
            ,2,'0'
         ) -- minute
         || ':' ||
         lpad(
            to_char(
               to_number(
                  substr(
                     highval_dump,
                     instr(highval_dump,',',1,6)+1
                  )
               )-1
            )
            ,2,'0'
         ) --second
         High_date
from (
        -- return just the date bytes from the dump()
        select substr(dump(low_value),15) lowval_dump ,substr(dump(high_value),15) highval_dump
        from DBA_tab_col_statistics
        where 
        OWNER='&owner'
        and table_name = '&Table_name'
        and column_name = '&Column_name'
) a
/
