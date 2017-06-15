set linesize 200 pageszie 2000

select name, position, datatype_string, was_captured, value_string,anydata.accesstimestamp(value_anydata)  from v$sql_bind_capture where sql_id = '&sql_id';
select inst_id,sid,sql_id,binds_xml  from gv$sql_monitor where sql_id='&sql_id';

