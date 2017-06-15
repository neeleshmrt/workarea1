SELECT *    FROM all_tab_cols   where 
owner = '&owner' and 
table_name = '&table_name' and 
virtual_column = 'YES';

SELECT extension_name, extension
FROM dba_stat_extensions
WHERE table_name='&Table_name';


--exec dbms_stats.create_extended_stats('CORE_TOTEM', 'TOTEM_FIELD_MAPPINGS', '("ASSETCLASS","SERVICENAME","PROCESSTYPE")');
--BEGIN
--   dbms_stats.gather_table_stats('CORE_TOTEM','TOTEM_FIELD_MAPPINGS',
--     method_opt=>'for all columns size skewonly for columns (ASSETCLASS,SERVICENAME,PROCESSTYPE)');
--END;
--/

--exec dbms_stats.drop_extended_stats('CORE_TOTEM', 'TOTEM_FIELD_MAPPINGS', '("ASSETCLASS","SERVICENAME","PROCESSTYPE")');

  
