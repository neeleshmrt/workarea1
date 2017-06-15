ORACLE_BASE=/opt/app/oracle
ORACLE_HOME=/opt/app/oracle/product/11.2.0.1
ORACLE_SID=amxdcmp1
PATH=/bin:/sbin:/usr/sbin:$HOME/bin:$ORACLE_HOME/bin:/usr/bin:$JAVA_HOME/bin:/opt/app/oracle/OPatch:$ORACLE_HOME/Apache/Apach
e/bin:$HOME/scripts:$HOME/DBA/SHOW
export ORACLE_BASE ORACLE_HOME ORACLE_SID
export PATH
MAIL_LIST="shilpa.jain1@amdocs.com"

cd ~oracle
SID=amxdcmp1
mkdir -p /tmp/awr/amxdcmp1
cd /tmp/awr/amxdcmp1

sqlplus -S system/pvcpipe@amxdcmp1 > endsnap.log << EOF
set pages 0 lines 100 feed off
select ltrim(max(snap_id)) FROM dba_hist_snapshot where BEGIN_INTERVAL_TIME like '22-MAY%' ;
exit
EOF

sqlplus -S system/pvcpipe@amxdcmp1 > minimumsnap.log << EOF
set pages 0 lines 100 feed off
col period for a40
select ltrim(min(snap_id)) FROM dba_hist_snapshot where BEGIN_INTERVAL_TIME like '20-MAY%';
exit
EOF

min_snap=`cat minimumsnap.log`
end_snap=`cat endsnap.log`
begin_snap=`expr $end_snap - 4`
report_name="awr_${SID}_${begin_snap}_${end_snap}"
echo $begin_snap $end_snap $min_snap $report_name

while [ $min_snap -lt $begin_snap ]
do
echo $begin_snap $end_snap $min_snap $report_name

sqlplus -S system/pvcpipe@amxdcmp1 << EOF
define report_type='html'
define num_days=5
define begin_snap=${begin_snap}
define end_snap=${end_snap}
define report_name=${report_name}.html
@?/rdbms/admin/awrrpt.sql
exit
EOF

sqlplus -S system/pvcpipe@amxdcmp1 << EOF
define report_type='text'
define num_days=5
define begin_snap=${begin_snap}
define end_snap=${end_snap}
define report_name=${report_name}.text
@?/rdbms/admin/awrrpt.sql
exit
EOF
end_snap=`expr $end_snap - 4`
begin_snap=`expr ${begin_snap} - 4`
report_name="awr_amxdcmp1_${begin_snap}_${end_snap}"
done

tar -cvzf AWR.tar.gz *.html *.text

