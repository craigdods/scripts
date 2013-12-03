#!/bin/sh
# Graphing script written by Craig Dods
# 15/02/2011
# Designed to be run from CRON
# */15 * * * * /bin/bash /home/admin/scripts/grapher.sh >> /home/admin/graph_log.csv 2>&1

#Source CP-ENV
source /etc/profile.d/CP.sh

DATE=$(/bin/date | awk '{print $2,$3,$4}' | awk -F":" '{print $1":"$2}')
CONN_COUNT=$(fw ctl pstat | grep -A3 Connections: | grep concurrent | grep -v peak | awk -F"," '{print $4}' | sed 's/^[ \t]*//;s/\ concurrent//g')

echo "$DATE,$CONN_COUNT"

