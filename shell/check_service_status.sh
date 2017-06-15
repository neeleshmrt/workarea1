#!/bin/ksh
# Author = senthil kumar Date: 09/16/2016
# References = From a Perl script by YONG HUANG
# Note = The concept was taken from a perl script and completely redisigned for Markit's monitoring requirement
# Purpose = checking if services are running on the right node or not Or if any sevice is down
# Maintenance needs
########### Modifications History ###########
# 1.0 Initial script rollout
#############################################

set -x
#export MAILDBA="senthil.kumar@markit.com"
export MAILDBA="MK-GTSProductionSupportOracle@markit.com"
export HOST=`hostname -s`

db=`ps -ef | grep ora_pmon | grep -v grep | awk '{print $8}' | cut -f 3 -d '_'`
#db=brd02qa1
for i in $db
do
export ORACLE_SID=$i
export ORACLE_HOME=`cat /etc/oratab | grep -iw $i |grep -v ^#| cut -f 2 -d ':'`
export PATH=$PATH:$ORACLE_HOME/bin
export DB_INFO=$(sqlplus -s / as sysdba << EOF
set echo off head off feed off
select db_unique_name,open_mode from v\$database;
exit;
EOF)
DB_STATUS=`echo "${DB_INFO}" | awk '{print $2}'`
READ_STATUS="READ"
if [[ "$DB_STATUS" == *"$READ_STATUS"* ]]
then
export DB_UNQ_NAME=`echo "${DB_INFO}" | awk '{print $1}'`
$ORACLE_HOME/bin/srvctl config service -d $DB_UNQ_NAME > /tmp/service_check_list.log
SRVLIST=`cat /tmp/service_check_list.log | grep "Service name" | awk '{print $3}'` 
for j in $SRVLIST 
do
PREFLIST=`$ORACLE_HOME/bin/srvctl config service -d $DB_UNQ_NAME -s $j | grep -e Preferred | awk '{print $3}'`
SUCCESS=`$ORACLE_HOME/bin/srvctl status service -d $DB_UNQ_NAME -s $j | grep "is running"`
if  [ -n "${SUCCESS}" ]
then
RUNLIST=`$ORACLE_HOME/bin/srvctl status service -d $DB_UNQ_NAME -s $j | awk '{print $7}'`
if [ "${PREFLIST}" != "${RUNLIST}" ]
then
echo "${DB_UNQ_NAME} --->  Service $j preferred instance list differs from service running instance list: *** Preferred : ->  $PREFLIST *** Running on: ->  $RUNLIST " >> /tmp/service_check_status.log
echo " " >> /tmp/service_check_status.log
else
echo "No issues found with the service"
fi
else
echo "${DB_UNQ_NAME} ---> !!! Critical !!!  Service  $j is down " >> /tmp/service_check_status.log
echo " " >> /tmp/service_check_status.log
fi
done
else
echo "Database is not in Open mode"
fi
done

cat /tmp/service_check_status.log | mail -s "CRITICAL: !!!!!!! Service Availability Problem !!!!!!! " $MAILDBA
rm /tmp/service_check*.log
