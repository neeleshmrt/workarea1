ORACLE_BASE=/opt/app/oracle
#ORACLE_HOME=/opt/app/oracle/product/11.1.0.6
#ORACLE_HOME=/opt/app/oracle/product/11.2.0.1
ORACLE_HOME=/opt/app/oracle/product/10.2.0.4
ORACLE_SID=qpinfra
ORACLE_OWNER=oracle
ORACLE_TERM=xterm
ORACLE_DOC=$ORACLE_HOME/doc
ORA_NLS33=$ORACLE_HOME/ocommon/nls/admin/data

JAVA_HOME=/usr/local/java
CLASSPATH=$JAVA_HOME/lib/classes.zip
PATH=/bin:/sbin:/usr/sbin:$HOME/bin:$ORACLE_HOME/bin:/usr/bin:$JAVA_HOME/bin:/opt/app/oracle/OPatch:$ORACLE_HOME/Apache/Apache/bin:$HOME/scripts:$HOME/DBA/SHOW
CLASSPATH=$ORACLE_HOME/jre:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib:$ORACLE_HOME/network/jlib
#TNS_ADMIN=$ORACLE_HOME/network/admin
TNS_ADMIN=$ORACLE_HOME/network/admin

LD_ASSUME_KERNEL=2.4.21
THREADS_FLAG=native

export ORACLE_BASE ORACLE_HOME ORACLE_SID ORACLE_TERM ORACLE_DOC ORA_NLS33
export ADMIN JAVA_HOME CLASSPATH DISPLAY PATH LD_LIBRARY_PATH CLASSPATH TNS_ADMIN
export LD_ASSUME_KERNEL THREADS_FLAG

export SQLPATH=/usr/local/sql:${HOME}/sql


if [ $# -lt 1 ]; then
echo "$0 <SID>"
exit
fi

#MAIL_LIST="pareshr@amdocs.com,biancai@amdocs.com"

MAIL_LIST="satishpe@amdocs.com"
#MAIL_LIST="shilpa.jain1@amdocs.com","qpassdbateam@amdocs.com"


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
begin_snap=`expr $end_snap - 4`

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

#gzip -f ${report_name}*.html
#gzip -f ${report_name}*.text
tar -cvzf ${report_name}.tar.gz ${report_name}*.html ${report_name}*.text

NOW=`date +%F-%T`
awrrpt=${report_name}.html.gz
awrrpt1=${report_name}.tar.gz
#uuencode $awrrpt $awrrpt | mail -s "awr report ${awrrpt} of ${SID} at ${NOW}"   pareshr@amdocs.com -c ${MAIL_LIST}
uuencode $awrrpt1 $awrrpt1 | mail -s "awr report ${awrrpt} of ${SID} at ${NOW}"   ${MAIL_LIST}

