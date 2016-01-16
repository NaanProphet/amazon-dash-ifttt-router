#!/bin/sh

# Note: launching the background script dash-listener.sh directly does not work, as it seems
# the router's boot process reinitializes or something. This is also evident
# by echoing the date into the /tmp/000servicesstarted, which is in the past:
# Wed Dec 31 19:00:25 EST 2014.
#
# However crontab modifications persist, thus adding a cron poll script
# to kick off the actual dash daemon if it's not already running.

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

