column "Diskgroup" format A30 
column "Imbalance" format 99.9 Heading "Percent|Imbalance"
column "Variance" format 99.9 Heading "Percent|Disk Size|Variance"
column "MinFree" format 99.9 Heading "Minimum|Percent|Free"
column "DiskCnt" format 9999 Heading "Disk|Count"
column "Type" format A10 Heading "Diskgroup|Redundancy"

 SELECT g.name "Diskgroup",
  100*(max((d.total_mb-d.free_mb)/d.total_mb)-min((d.total_mb-d.free_mb)/d.total_mb))/max((d.total_mb-d.free_mb)/d.total_mb) "Imbalance",
  100*(max(d.total_mb)-min(d.total_mb))/max(d.total_mb) "Variance",
  100*(min(d.free_mb/d.total_mb)) "MinFree",
  count(*) "DiskCnt",
  g.type "Type"
FROM v$asm_disk d, v$asm_diskgroup g
WHERE d.group_number = g.group_number and
  d.group_number <> 0 and
  d.state = 'NORMAL' and
  d.mount_status = 'CACHED'
GROUP BY g.name, g.type order by 2;
