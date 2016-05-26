#
# SRX Monitoring Script written by Craig Dods @ IBM MSS
# 
# Last update on March 17th, 2016
#
# This script is provided for informational purposes only and comes with absolutely with NO WARRANTY
# 
# User assumes all risk.
#
# Scripts should be installed into CRON in the following format
# * 1 * * * sh /cf/root/app-prod_script.sh

CURRENT_TIME=$(date +"%Y-%m-%d-%H%M")
LOGFILE="INTRA-app-prod-log-$CURRENT_TIME.txt"

/usr/sbin/cli show security flow session node 0 | grep -v Policy | awk '{print $2,$4}' | awk NF > /var/tmp/$LOGFILE
/usr/sbin/cli show ...whatever
