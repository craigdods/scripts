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

sleep_time=60

# Configure your interfaces here (will be updated to do this automatically in the future)
int1=eth0
int2=eth4
int3=eth5
int4=eth6
int5=eth7
int6=eth8

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
		echo "============== Network Statistics ==============="
		echo -n $int1 && ethtool -S $int1 | grep -e rx_bytes -e tx_bytes | sed ':a;$b;N;s/\n//;ba' | sed 's/[rx_bytes:]//g'
		echo -n $int2 && ethtool -S $int2 | grep -e rx_bytes -e tx_bytes | sed ':a;$b;N;s/\n//;ba' | sed 's/[rx_bytes:]//g'
		echo -n $int3 && ethtool -S $int3 | grep -e rx_bytes -e tx_bytes | sed ':a;$b;N;s/\n//;ba' | sed 's/[rx_bytes:]//g'
		echo -n $int4 && ethtool -S $int4 | grep -e rx_bytes -e tx_bytes | sed ':a;$b;N;s/\n//;ba' | sed 's/[rx_bytes:]//g'
		echo -n $int5 && ethtool -S $int5 | grep -e rx_bytes -e tx_bytes | sed ':a;$b;N;s/\n//;ba' | sed 's/[rx_bytes:]//g'
		echo -n $int6 && ethtool -S $int6 | grep -e rx_bytes -e tx_bytes | sed ':a;$b;N;s/\n//;ba' | sed 's/[rx_bytes:]//g'


	echo "}}}"
	sleep $sleep_time
done >> $LOG_FILE




