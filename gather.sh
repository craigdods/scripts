#!/bin/sh
# Information gathering script written by Craig Dods
# 15/02/2011
# This script is provided for debugging purposes only
# with no warranty. User assumes all risk
#
# Interrupt this script with a Control-C to stop
#

# Collect stats once per $sleep_time, in sec. Tunable.
# 5 min by default, 86400 seconds = 1 day
sleep_time=5

cur_time=`date +'%m%d%H%M%S'`
LOG_FILE="CP-$cur_time.log"

trap cleanup 2 3 5 6 9 11
cleanup ()
{
	echo > /dev/tty
	echo "Submit $LOG_FILE to support site" > /dev/tty
	exit 0
}

exec_cmd ()
{
	echo "================ output of $1 =================="
	eval $1
}

# collect stats per $sleep_time.
while : 
do
	cur_time=`date`
	echo "$cur_time {{{"

		echo "============== Hostname ==============="
		hostname
		echo "============== Uptime ==============="
		uptime
		echo "============== vmstat 1 2 ==============="
		vmstat 1 2
		echo "============== vmstat -ms ==============="
		vmstat -ms
		echo "============== cpstat -f memory os ==============="
		cpstat -f memory os

	echo "}}}"
	sleep $sleep_time
done >> $LOG_FILE




