#!/bin/sh

### Child script for triggering an IFTTT action from an Amazon Dash button press.
### Expects the mac address of the button as the first and only argument. Looks up
### the MAC id in a map file using AWK and invokes the event via CURL.

# Use your own IFTTT key, not this fake one
IFTTT_KEY=9cn3847ntc8394tn8-ab
# Mapping file from Dash MAC address key to Maker event name values
# Space delimited, two columns minimum. Additional columns could be 
# used and defined as needed
MAPPING_FILE=dashlookup.txt
AWK_SCRIPT=lookupf.awk

DIR="$( cd "$( dirname "$0" )" && pwd )"
COLUMN_EVENT_NAME=2
MAC_CLICKED=$1
EVENT=`$DIR/$AWK_SCRIPT $MAC_CLICKED $COLUMN_EVENT_NAME $DIR/$MAPPING_FILE`

if [[ ! -z "$EVENT" ]]
then
  MAKER_URL="https://maker.ifttt.com/trigger/${EVENT}/with/key/${IFTTT_KEY}"
  echo "Calling ${MAKER_URL} for mac address $1"
  curl -X POST "${MAKER_URL}"
  echo ""
else
  echo "Ignoring input! No action defined for MAC address $1"
fi
