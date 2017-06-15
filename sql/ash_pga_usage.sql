select pid
     , spid
     , s.inst_id
     , s.username
     , s.module
     , s.action
     , s.client_identifier
     , pga_alloc_mem/(1024*1024)
from   gv$process p
     , gv$session s
where  s.paddr = p.addr
and    s.inst_id = p.inst_id
order by pga_alloc_mem desc;
