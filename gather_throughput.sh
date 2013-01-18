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

. /etc/profile.d/CP.sh

sleep_time=1

# Configure your interfaces here (will be updated to do this automatically in the future)
int1=DMZ
int2=Internal
int3=External
int4=Lan1
int5=Lan2
int6=Lan3
#int7=Lan2.405
#int8=Lan2.406
#int9=Lan2.407
#int10=Lan2.408


cur_time=`date +'%m%d%H%M%S'`
LOG_FILE="CP-TP-$cur_time.log"

trap cleanup 2 3 5 6 9 11
cleanup ()
{
	echo > /dev/tty
	echo "Submit $LOG_FILE to Craig for analysis" > /dev/tty
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
	echo " "

		echo -n $int1 && ethtool -S $int1 | grep -e rx_bytes -e tx_bytes | sed ':a;$b;N;s/\n//;ba' | sed 's/[rx_bytes:]//g'
		echo -n $int2 && ethtool -S $int2 | grep -e rx_bytes -e tx_bytes | sed ':a;$b;N;s/\n//;ba' | sed 's/[rx_bytes:]//g'
		echo -n $int3 && ethtool -S $int3 | grep -e rx_bytes -e tx_bytes | sed ':a;$b;N;s/\n//;ba' | sed 's/[rx_bytes:]//g'
		echo -n $int4 && ethtool -S $int4 | grep -e rx_bytes -e tx_bytes | sed ':a;$b;N;s/\n//;ba' | sed 's/[rx_bytes:]//g'
		echo -n $int5 && ethtool -S $int5 | grep -e rx_bytes -e tx_bytes | sed ':a;$b;N;s/\n//;ba' | sed 's/[rx_bytes:]//g'
		echo -n $int6 && ethtool -S $int6 | grep -e rx_bytes -e tx_bytes | sed ':a;$b;N;s/\n//;ba' | sed 's/[rx_bytes:]//g'
		#echo -n $int7 && ethtool -S $int7 | grep -e rx_bytes -e tx_bytes | sed ':a;$b;N;s/\n//;ba' | sed 's/[rx_bytes:]//g'
		#echo -n $int8 && ethtool -S $int8 | grep -e rx_bytes -e tx_bytes | sed ':a;$b;N;s/\n//;ba' | sed 's/[rx_bytes:]//g'
		#echo -n $int9 && ethtool -S $int9 | grep -e rx_bytes -e tx_bytes | sed ':a;$b;N;s/\n//;ba' | sed 's/[rx_bytes:]//g'
		#echo -n $int10 && ethtool -S $int10 | grep -e rx_bytes -e tx_bytes | sed ':a;$b;N;s/\n//;ba' | sed 's/[rx_bytes:]//g'



	echo " "
	sleep $sleep_time
done >> $LOG_FILE




