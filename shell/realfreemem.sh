#!/bin/ksh

FREEMEM=`cat /proc/meminfo | grep MemFree: | sed -e 's/ */ /g' | cut -f2 -d' '`
CACHED=`cat /proc/meminfo | grep Cached: | grep -v SwapCached: | sed -e 's/ */ /g' | cut -f2 -d' '`
TOTALMEM=`cat /proc/meminfo | grep MemTotal: | sed -e 's/ */ /g' | cut -f2 -d' '`

((FREEMEM=${FREEMEM}/1024))
((CACHED=${CACHED}/1024))
((TOTALMEM=${TOTALMEM}/1024))

((TOTALFREE=${FREEMEM}+${CACHED}))
((REALFREE=$TOTALFREE*100))
#((REALFREEPCT=$REALFREE/$TOTALMEM))

if [ "$1" = "-a" ]; then
echo 'Free Memory:' ${FREEMEM}'M'
echo 'Cached Memory:' ${CACHED}'M'
echo 'Total Free Memory:' ${TOTALFREE}'M'
echo 'Total Memory:' ${TOTALMEM}'M'
#echo 'Percent Memory Free (including cache):' ${REALFREEPCT}'%'
#else
#echo 'Percent Memory Free (including cache):' ${REALFREEPCT}'%'
fi

return $REALFREEPC
