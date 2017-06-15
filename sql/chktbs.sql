set linesize 200 pagesize 2000

      SELECT a.tablespace_name,
        a."Total(GB)",
        nvl(b."Free(GB)",0) + nvl(a."Extend(GB)",0) "Free(GB)",
        nvl(b."Max(GB)",0)  "Max(GB)",
        100 * (nvl(b."Free(GB)",0) + nvl(a."Extend(GB)",0))/a."Total(GB)" "% Free"
   FROM  (SELECT tablespace_name,
                 sum(decode(autoextensible,'YES',maxbytes,bytes))/1024/1024/1024 "Total(GB)",
                sum(decode(autoextensible,'YES',(maxbytes - bytes),0))/1024/1024/1024 "Extend(GB)"
            FROM dba_data_files
        GROUP BY tablespace_name) a,
         (SELECT tablespace_name,
                 sum(bytes)/1024/1024/1024 "Free(GB)",
                 max(bytes)/1024/1024/1024 "Max(GB)"
            FROM dba_free_space
        GROUP BY tablespace_name) b
  WHERE   
--  a.tablespace_name like '&a' and 
  a.tablespace_name = b.tablespace_name (+)  
--and   100 * (nvl(b."Free(GB)",0) + nvl(a."Extend(GB)",0))/a."Total(GB)" < 20 
;
