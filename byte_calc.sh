#!/bin/bash

# Configure your interfaces here (will be updated to do this automatically in the future)
int1=Internal
int2=External
int3=DMZ
int4=Lan1
int5=Lan2
int6=Lan3
# Sleep time (in minutes) that the data was collected over
time=5

echo "Hello, please enter the correct log file to analyze"
ls | grep CP-
read logfile

echo " "
echo $logfile "has been chosen"

iterations=`grep -c $int1 $logfile`


echo "There were" $iterations "recordings $time minutes apart"

int1_byte_rx=`cat $logfile | grep $int1 | awk '{print $2}' | awk '{sum+=$1} END {print sum}'`
int1_byte_tx=`cat $logfile | grep $int1 | awk '{print $10}' | awk '{sum+=$1} END {print sum}'`
int1_rx_thrpt=`echo "($int1_byte_rx * 0.00000762939453)  / $iterations / ($time * 60)" | bc -l`
int1_tx_thrpt=`echo "($int1_byte_tx * 0.00000762939453)  / $iterations / ($time * 60)" | bc -l`

int2_byte_rx=`cat $logfile | grep $int2 | awk '{print $2}' | awk '{sum+=$1} END {print sum}'`
int2_byte_tx=`cat $logfile | grep $int2 | awk '{print $10}' | awk '{sum+=$1} END {print sum}'`
int2_rx_thrpt=`echo "($int2_byte_rx * 0.00000762939453)  / $iterations / ($time * 60)" | bc -l`
int2_tx_thrpt=`echo "($int2_byte_tx * 0.00000762939453)  / $iterations / ($time * 60)" | bc -l`

int3_byte_rx=`cat $logfile | grep $int3 | awk '{print $2}' | awk '{sum+=$1} END {print sum}'`
int3_byte_tx=`cat $logfile | grep $int3 | awk '{print $10}' | awk '{sum+=$1} END {print sum}'`
int3_rx_thrpt=`echo "($int3_byte_rx * 0.00000762939453)  / $iterations / ($time * 60)" | bc -l`
int3_tx_thrpt=`echo "($int3_byte_tx * 0.00000762939453)  / $iterations / ($time * 60)" | bc -l`

int4_byte_rx=`cat $logfile | grep $int4 | awk '{print $2}' | awk '{sum+=$1} END {print sum}'`
int4_byte_tx=`cat $logfile | grep $int4 | awk '{print $10}' | awk '{sum+=$1} END {print sum}'`
int4_rx_thrpt=`echo "($int4_byte_rx * 0.00000762939453)  / $iterations / ($time * 60)" | bc -l`
int4_tx_thrpt=`echo "($int4_byte_tx * 0.00000762939453)  / $iterations / ($time * 60)" | bc -l`

int5_byte_rx=`cat $logfile | grep $int5 | awk '{print $2}' | awk '{sum+=$1} END {print sum}'`
int5_byte_tx=`cat $logfile | grep $int5 | awk '{print $10}' | awk '{sum+=$1} END {print sum}'`
int5_rx_thrpt=`echo "($int5_byte_rx * 0.00000762939453)  / $iterations / ($time * 60)" | bc -l`
int5_tx_thrpt=`echo "($int5_byte_tx * 0.00000762939453)  / $iterations / ($time * 60)" | bc -l`


int6_byte_rx=`cat $logfile | grep $int6 | awk '{print $2}' | awk '{sum+=$1} END {print sum}'`
int6_byte_tx=`cat $logfile | grep $int6 | awk '{print $10}' | awk '{sum+=$1} END {print sum}'`
int6_rx_thrpt=`echo "($int6_byte_rx * 0.00000762939453)  / $iterations / ($time * 60)" | bc -l`
int6_tx_thrpt=`echo "($int6_byte_tx * 0.00000762939453)  / $iterations / ($time * 60)" | bc -l`


int1_total=`echo $int1_rx_thrpt + $int1_tx_thrpt | bc -l`
echo "Total average" $int1 "interface throughput (send and receive) in mbps:" $int1_total

int2_total=`echo $int2_rx_thrpt + $int2_tx_thrpt | bc -l`
echo "Total average" $int2 "interface throughput (send and receive) in mbps:" $int2_total

int3_total=`echo $int3_rx_thrpt + $int3_tx_thrpt | bc -l`
echo "Total average" $int3 "interface throughput (send and receive) in mbps:" $int3_total

int4_total=`echo $int4_rx_thrpt + $int4_tx_thrpt | bc -l`
echo "Total average" $int4 "interface throughput (send and receive) in mbps:" $int4_total

int5_total=`echo $int5_rx_thrpt + $int5_tx_thrpt | bc -l`
echo "Total average" $int5 "interface throughput (send and receive) in mbps:" $int5_total

int6_total=`echo $int6_rx_thrpt + $int6_tx_thrpt | bc -l`
echo "Total average" $int6 "interface throughput (send and receive) in mbps:" $int6_total

echo " "

total_agg=`echo $int1_total + $int2_total + $int3_total +$int4_total + $int5_total + $int6_total | bc -l`
echo "Total average aggregate device throughput (send and receive) in mbps:" $total_agg










