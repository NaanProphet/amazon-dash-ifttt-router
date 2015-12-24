#!/bin/sh

### This script will grep for the initial DHCPDISCOVER broadcast signal 
### and pipe the regex'ed MAC address to the action-routing script

### Example log printout:
### Dec 24 06:21:09 dnsmasq-dhcp[451]: DHCPDISCOVER(br0) f0:27:2d:a4:db:6c 
### Dec 24 06:21:09 dnsmasq-dhcp[451]: DHCPOFFER(br0) 192.168.1.62 f0:27:2d:a4:db:6c 
### Dec 24 06:21:09 dnsmasq-dhcp[451]: DHCPREQUEST(br0) 192.168.1.62 f0:27:2d:a4:db:6c 
### Dec 24 06:21:09 dnsmasq-dhcp[451]: DHCPACK(br0) 192.168.1.62 f0:27:2d:a4:db:6c 

### Note: this approach uses AWK because 
### (1) router doesn't have GNU grep's grep's --line-buffered option
### (2) AWK supports regex
### (3) AWK's default is line buffering

### special thanks to:
### (post 6) http://objectmix.com/awk/320822-pattern-matching-shell-variable-inside-awk.html
### http://stackoverflow.com/questions/7161821/how-to-grep-a-continuous-stream
### http://stackoverflow.com/questions/157163/how-to-do-something-with-bash-when-a-text-line-appear-to-a-file
### http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
### http://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself

# note: pattern checks for space before MAC address, necessary assumption for splitting
DIR="$( cd "$( dirname "$0" )" && pwd )"
REGEX="DHCPDISCOVER.* (..:..:..:..:..:..)"                                                  
LOGFILE="/tmp/syslog.log"
# relative location to the child script
DASH_TRIGGER=dash-trigger.sh

tail -f -n0 ${LOGFILE}  | while read LOGLINE

do

  # note: escaping space after AWK pattern with \
  MAC=`echo ${LOGLINE} | awk /"$REGEX"/\ '{print $NF}'`
  #echo "MAC is: ${MAC}"

  if [[ ! -z "$MAC" ]]
  then
    sh "$DIR/$DASH_TRIGGER" "$MAC"
  fi

done
