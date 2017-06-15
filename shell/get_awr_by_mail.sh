export TNS_ADMIN=$ORACLE_HOME/network/admin
if [ $# -lt 1 ]; then
echo "$0 <SID>"
exit
fi

MAIL_LIST="neelesh.sharma@amdocs.com"

cd ~oracle
source .bash_profile
SID=$1
mkdir -p /tmp/awr/${SID}
cd /tmp/awr/${SID}
snptime=`date +%D:%H:%M`
#snptime=`date +%D:%H`:00
echo $snptime
#begin_snap=`sqlplus -s system/pvcpipe@$SID << EOF
#set pages 0 lines 100 feed off
#col period for a40
#alter session set nls_timestamp_format='mm/dd/yy:hh24:mi';
#select ltrim(snap_id)   FROM dba_hist_snapshot where to_date('$snptime','mm/dd/yy:hh24:mi')-(1/24) between BEGIN_INTERVAL_TIME  and END_INTERVAL_TIME;
#EOF`

end_snap=`sqlplus -s system/pvcpipe@$SID << EOF
set pages 0 lines 100 feed off
col period for a40
alter session set nls_timestamp_format='mm/dd/yy:hh24:mi';
select ltrim(max(snap_id))   FROM dba_hist_snapshot ;
EOF`
begin_snap=`expr $end_snap - 2`

report_name="awr_${SID}_${end_snap}"

echo $begin_snap $end_snap $report_name
#exit

sqlplus -s system/pvcpipe@$SID << EOF
define report_type='html'
define num_days=1
define begin_snap=${begin_snap}
define end_snap=${end_snap}
define report_name=${report_name}.html
@?/rdbms/admin/awrrpt.sql
exit
EOF

sqlplus -s system/pvcpipe@$SID << EOF
define report_type='text'
define num_days=1
define begin_snap=${begin_snap}
define end_snap=${end_snap}
define report_name=${report_name}.text
@?/rdbms/admin/awrrpt.sql
exit
EOF

gzip -f ${report_name}*.html
gzip -f ${report_name}*.text
#tar -cvzf ${report_name}.tar.gz ${report_name}*.html ${report_name}*.text

NOW=`date +%F-%T`
awrrpt=${report_name}.html.gz
awrrpt1=${report_name}.tar.gz
#uuencode $awrrpt $awrrpt | mail -s "awr report ${awrrpt} of ${SID} at ${NOW}"   pareshr@amdocs.com -c ${MAIL_LIST}
uuencode ${report_name}.html.gz ${report_name}.html.gz | mail -s "awr report ${awrrpt} of ${SID} at ${NOW}"   ${MAIL_LIST}
#uuencode $awrrpt1 $awrrpt1 | mail -s "awr report ${awrrpt} of ${SID} at ${NOW}"   ${MAIL_LIST}

