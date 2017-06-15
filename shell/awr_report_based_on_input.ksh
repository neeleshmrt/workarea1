echo "enter the begin date mm/dd/yy format"
read begin_date
echo "enter the begin time hh24:mi format"
read begin_time
echo "enter the end date mm/dd/yy format"
read end_date
echo "enter the end time hh24:mi format"
read end_time
echo "enter the interval to extract awr report 1 means 15 min 2-> 30 min 3->45 min 4-> 1 hour etc.."
read inval

ORACLE_BASE=/opt/app/oracle
ORACLE_HOME=/opt/app/oracle/product/11.2.0.2
ORACLE_SID=cinprds1
PATH=/bin:/sbin:/usr/sbin:$HOME/bin:$ORACLE_HOME/bin:/usr/bin:$JAVA_HOME/bin:/opt/app/oracle/OPatch:$ORACLE_HOME/Apache/Apache/bin:$HOME/scripts:$HOME/DBA/SHOW
export ORACLE_BASE ORACLE_HOME ORACLE_SID
export PATH
cd ~/


bsnap=/tmp/bsnap.out

sqlplus / as sysdba > ${bsnap} << EOF
set echo off heading off

select 'Begin_Snap_Id='||min(snap_id)
from dba_hist_snapshot
where trim(to_char(end_interval_time,'HH24:MI')) >= '${begin_time}'
and
trim(to_char(end_interval_time, 'mm/dd/yy'))='${begin_date}';

exit;
EOF

esnap=/tmp/esnap.out

sqlplus / as sysdba > ${esnap} <<EOF
set echo off heading off
select 'End_Snap_Id='||max(snap_id)
from dba_hist_snapshot
where trim(to_char(end_interval_time,'HH24:MI')) <= '${end_time}'
and
trim(to_char(end_interval_time, 'mm/dd/yy'))= '${end_date}';


exit;
EOF


bsnapid=`cat ${bsnap} |grep Begin_Snap_Id |awk -F= '{print $2}'`
esnapid=`cat ${esnap} |grep End_Snap_Id |awk -F= '{print $2}'`

echo $bsnapid
echo $esnapid

i=$bsnapid
j=$bsnapid


mkdir -p /tmp/awr_pet/${SID}
cd /tmp/awr_pet/${SID}

while [ $j -lt $esnapid ]
do
j=`expr $i + ${inval}`
echo $i $j
sqlplus -s / as sysdba << EOF
define report_type='html'
define num_days=1
define begin_snap=${i}
define end_snap=${j}
define report_name=${i}_AWR.htm
@?/rdbms/admin/awrrpt.sql
exit
EOF
i=`expr $i + ${inval}`
done


