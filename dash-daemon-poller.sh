#!/bin/sh

# add this to crontab to run every minute, e.g.
# cru a dash "* * * * * /mnt/OPTWARE/dash/dash-daemon-poller.sh > /dev/null 2>&1"

CHILD_SCRIPT=dash-listener.sh
LOGFILE=/tmp/mnt/OPTWARE/dash/dash.log

count=`ps | grep ${CHILD_SCRIPT} | wc -l`

# grep always counts itself, hence the 2
if [ $count -lt 2 ]
then
 echo "Dash listener not yet running, starting up ..." > $LOGFILE
 sh /tmp/mnt/OPTWARE/dash/dash-listener.sh >> $LOGFILE 2>&1 &
fi

