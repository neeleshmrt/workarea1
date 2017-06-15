 set linesize 200 pages 2000
col NAME for a5
col VALUE_STRING for a20
col anydata.accesstimestamp(value_anydata)  for a30

SELECT NAME,SNAP_ID ,POSITION,DATATYPE_STRING,VALUE_STRING ,anydata.accesstimestamp(value_anydata) FROM DBA_HIST_SQLBIND WHERE SQL_ID='&sqlid' order by SNAP_ID,NAME;

