EXECUTE DBMS_STATS.CREATE_STAT_TABLE ('NEESHARMA','ISDASELLSIDEPRODUCTTYPES_STAT');
BEGIN dbms_stats.export_table_stats (ownname=>'MTMPROD', tabname =>'ISDASELLSIDEPRODUCTTYPES', stattab=>'ISDASELLSIDEPRODUCTTYPES_STAT',statown=>'NEESHARMA',  cascade=>TRUE); END;
BEGIN dbms_stats.import_table_stats (ownname=>'MTMPROD', tabname =>'ISDASELLSIDEPRODUCTTYPES', stattab=>'ISDASELLSIDEPRODUCTTYPES_STAT',statown=>'NEESHARMA', cascade=>TRUE,FORCE => TRUE); END;                  


