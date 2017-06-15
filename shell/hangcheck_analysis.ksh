#!/bin/ksh -p
#============================================================================
# File:         hangcheck_analysis.ksh
# Type:         UNIX korn-shell script
#============================================================================
set -x
Pgm=chk_waits
#
#----------------------------------------------------------------------------
# Set the correct PATH for the script...
#----------------------------------------------------------------------------
PATH=/bin:/usr/bin:/usr/local/bin; export PATH
#
#----------------------------------------------------------------------------
# Korn-shell function to be called multiple times in the script...
#----------------------------------------------------------------------------
notify_via_email()
{
        cat << __EOF__ | mailx -s "$Pgm $OraSid" neelesh.sharma@markit.com
$ErrMsg
__EOF__
}
#
#----------------------------------------------------------------------------
# Korn-shell function to be called multiple times in the script...
#----------------------------------------------------------------------------
hanganalyze() # ...take a level 3 hanganalyze via SQL*Plus...
{
        set -x
        typeset Rtn=0

        sqlplus -s /nolog <<__EOF__ > /dev/null 2>&1
whenever oserror exit 8
whenever sqlerror exit 8
connect / as sysdba
whenever oserror exit 9
set echo off feed off pages 0 lines 200 veri off head off
spool $HAFile
whenever sqlerror exit 10
oradebug setmypid
oradebug tracefile_name
oradebug unlimit
oradebug hanganalyze 3
host sleep 30
oradebug hanganalyze 3
host sleep 30
oradebug hanganalyze 3
host sleep 30
oradebug hanganalyze 3
host sleep 30
oradebug hanganalyze 3
__EOF__
        return $?
} # ...end of shell function "hanganalyze"...
#
#----------------------------------------------------------------------------
# Verify that the ORACLE_SID has been specified on the UNIX command-line...
#----------------------------------------------------------------------------
if (( $# != 1 ))
then
echo "Usage: $Pgm.sh ORACLE_SID; aborting..."
        exit 1
fi
OraSid=$1
#
#----------------------------------------------------------------------------
# Verify that the database instance specified is "up"...
#----------------------------------------------------------------------------
Up=`ps -eaf | grep ora_pmon_${OraSid} | grep -v grep | awk '{print $NF}'`
if [[ -z $Up ]]
then
exit 3
fi
#
#----------------------------------------------------------------------------
# Verify that the ORACLE_SID is registered in the ORATAB file...
#----------------------------------------------------------------------------
dbhome $OraSid > /dev/null 2>&1
if (( $? != 0 ))
then
echo "$Pgm: \"$OraSid\" not local to this host; aborting..."
        exit 4
fi
#
#----------------------------------------------------------------------------
# Set the Oracle environment variables for this database instance...
#----------------------------------------------------------------------------
export ORACLE_SID=$OraSid
export ORAENV_ASK=NO
. oraenv > /dev/null 2>&1
unset ORAENV_ASK
#----------------------------------------------------------------------------
# Locate the "spool" file for the SQL*Plus report and hanganalyze output...
#----------------------------------------------------------------------------
HAFile=/tmp/${Pgm}_$ORACLE_SID_hanganalyze.lst
SpoolFile=/tmp/${Pgm}_$ORACLE_SID.lst
#
#----------------------------------------------------------------------------
# Connect via SQL*Plus and produce the report...
#----------------------------------------------------------------------------
sqlplus -s /nolog << __EOF__ > /dev/null 2>&1
whenever oserror exit 8
whenever sqlerror exit 8
connect / as sysdba
whenever oserror exit 9
col event for a48
set echo off feedb off timi off pau off pages 60 lines 32767 trimsp on head on
spool $SpoolFile
whenever sqlerror exit 10
select inst_id, sid, serial#, sql_id, event, round(wait_time_micro / 1000,2) msecs
from   gv\$session
where  state = 'WAITING'
--and    event in ('control file sequential read', 'db file sequential read')
--and    wait_time_micro >= 10 * 1000000
/
__EOF__
#
#----------------------------------------------------------------------------
# If SQL*Plus exited with a failure status, then exit the script also...
#----------------------------------------------------------------------------
Rtn=$?
if (( $Rtn != 0 ))
then
        case "$Rtn" in
                8 ) ErrMsg="$Pgm: Cannot connect using \"CONNECT / AS SYSDBA\"";;
                9 ) ErrMsg="$Pgm: spool of report failed";;
                10) ErrMsg="$Pgm: query in report failed" ;;
        esac
        notify_via_email
        exit $Rtn
fi
#
#----------------------------------------------------------------------------
# If the report contains something, then notify the authorities!
#----------------------------------------------------------------------------
if [ -s $SpoolFile ]
then
        ErrMsg="$Pgm: WARNING - SESSIONS WAITING ON DB FILE OR CONTROL FILE SEQUENTIAL READ FOR MORE THAN 10 SECONDS HAVE BEEN DETECTED. STARTING HANGANALYZE LEVEL 3...

$(cat $SpoolFile)"
        notify_via_email
        hanganalyze
        HARtn=$?
        if (( $HARtn != 0 ))
        then
                case "$HARtn" in
                        8 ) ErrMsg="$Pgm: Cannot connect using \"CONNECT / AS SYSDBA\"";;
                        9 ) ErrMsg="$Pgm: spool of hanganalyze output failed";;
                        10) ErrMsg="$Pgm: hanganalyze failed" ;;
                esac
                notify_via_email
                exit $HARtn
        fi
        ErrMsg="$Pgm: INFO - HANGANALYZE IS COMPLETE

$(grep 'Hang Analysis in ' $HAFile | sort -u)"
        notify_via_email
        rm -f $SpoolFile
        rm -f $HAFile
        exit 11
else
rm -f $SpoolFile
fi
#
#----------------------------------------------------------------------------
# Return the exit status from SQL*Plus...
#----------------------------------------------------------------------------
exit 0

