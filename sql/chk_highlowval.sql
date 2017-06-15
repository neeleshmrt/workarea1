create or replace function raw_to_num(i_raw raw)
return number
as
    m_n number;
begin
    dbms_stats.convert_raw_value(i_raw,m_n);
    return m_n;
end;
/  
 
create or replace function raw_to_date(i_raw raw)
return date
as
    m_n date;
begin
    dbms_stats.convert_raw_value(i_raw,m_n);
    return m_n;
end;
/  
 
create or replace function raw_to_varchar2(i_raw raw)
return varchar2
as
    m_n varchar2(200);
begin
    dbms_stats.convert_raw_value(i_raw,m_n);
    return m_n;
end;
/ 

set linesize 200 pagesize 2000
col owner for a20
col table_name for a35
col LOW_VALUE for a25
col HIGH_VALUE for a35
col DATA_TYPE for a20

select 
        owner,table_name,column_name,DATA_TYPE,
        decode(data_type,
                'VARCHAR2',to_char(raw_to_varchar2(low_value)),
                'DATE',to_char(raw_to_date(low_value)),
                'NUMBER',to_char(raw_to_num(low_value))
        ) low_value,
        decode(data_type,
                'VARCHAR2',to_char(raw_to_varchar2(high_value)),
                'DATE',to_char(raw_to_date(high_value)),
                'NUMBER',to_char(raw_to_num(high_value))
        ) high_value
from DBA_tab_columns 
where table_name='&Table_name';

drop  function raw_to_num ;
drop function raw_to_date ;
drop function raw_to_varchar2 ;
