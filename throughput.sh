#!/bin/bash -x

# Configure your interfaces here (will be updated to do this automatically in the future)
int1=eth0
int2=eth4
int3=eth5
int4=eth6
int5=eth7
int6=eth8
# Sleep time (in seconds) that the data was collected over
time=6

echo "Hello, please enter the correct log file to analyze"
ls | grep CP-TP
read logfile

echo " "
echo $logfile "has been chosen"

iterations=`grep -c $int1 $logfile`
echo $iterations

echo "There were" $iterations "recordings $time seconds apart"

# Math time

# Original values
int1_orig_rx_bytes=`cat $logfile | grep $int1 | head -n 1 |awk '{print$2}'`
int2_orig_rx_bytes=`cat $logfile | grep $int2 | head -n 1 |awk '{print$2}'`
int3_orig_rx_bytes=`cat $logfile | grep $int3 | head -n 1 |awk '{print$2}'`
int4_orig_rx_bytes=`cat $logfile | grep $int4 | head -n 1 |awk '{print$2}'`
int5_orig_rx_bytes=`cat $logfile | grep $int5 | head -n 1 |awk '{print$2}'`
int6_orig_rx_bytes=`cat $logfile | grep $int6 | head -n 1 |awk '{print$2}'`

int1_orig_tx_bytes=`cat $logfile | grep $int1 | head -n 1 |awk '{print$3}'`
int2_orig_tx_bytes=`cat $logfile | grep $int2 | head -n 1 |awk '{print$3}'`
int3_orig_tx_bytes=`cat $logfile | grep $int3 | head -n 1 |awk '{print$3}'`
int4_orig_tx_bytes=`cat $logfile | grep $int4 | head -n 1 |awk '{print$3}'`
int5_orig_tx_bytes=`cat $logfile | grep $int5 | head -n 1 |awk '{print$3}'`
int6_orig_tx_bytes=`cat $logfile | grep $int6 | head -n 1 |awk '{print$3}'`

# Total Sums

int1_rx_bytes=`cat $logfile | grep $int1 | awk '{print $2}' | awk '{sum+=$1} END {printf "%f", sum}'`
int2_rx_bytes=`cat $logfile | grep $int2 | awk '{print $2}' | awk '{sum+=$1} END {printf "%f", sum}'`
int3_rx_bytes=`cat $logfile | grep $int3 | awk '{print $2}' | awk '{sum+=$1} END {printf "%f", sum}'`
int4_rx_bytes=`cat $logfile | grep $int4 | awk '{print $2}' | awk '{sum+=$1} END {printf "%f", sum}'`
int5_rx_bytes=`cat $logfile | grep $int5 | awk '{print $2}' | awk '{sum+=$1} END {printf "%f", sum}'`
int6_rx_bytes=`cat $logfile | grep $int6 | awk '{print $2}' | awk '{sum+=$1} END {printf "%f", sum}'`

int1_tx_bytes=`cat $logfile | grep $int1 | awk '{print $3}' | awk '{sum+=$1} END {printf "%f", sum}'`
int2_tx_bytes=`cat $logfile | grep $int2 | awk '{print $3}' | awk '{sum+=$1} END {printf "%f", sum}'`
int3_tx_bytes=`cat $logfile | grep $int3 | awk '{print $3}' | awk '{sum+=$1} END {printf "%f", sum}'`
int4_tx_bytes=`cat $logfile | grep $int4 | awk '{print $3}' | awk '{sum+=$1} END {printf "%f", sum}'`
int5_tx_bytes=`cat $logfile | grep $int5 | awk '{print $3}' | awk '{sum+=$1} END {printf "%f", sum}'`
int6_tx_bytes=`cat $logfile | grep $int6 | awk '{print $3}' | awk '{sum+=$1} END {printf "%f", sum}'`

# Sums minus the original values and converted to Mbps
int1_rx_thrpt=`echo "(($int1_rx_bytes - $int1_orig_rx_bytes) * 0.00000762939453)  / $iterations / $time" | bc -l`
int2_rx_thrpt=`echo "(($int2_rx_bytes - $int2_orig_rx_bytes) * 0.00000762939453)  / $iterations / $time" | bc -l`
int3_rx_thrpt=`echo "(($int3_rx_bytes - $int3_orig_rx_bytes) * 0.00000762939453)  / $iterations / $time" | bc -l`
int4_rx_thrpt=`echo "(($int4_rx_bytes - $int4_orig_rx_bytes) * 0.00000762939453)  / $iterations / $time" | bc -l`
int5_rx_thrpt=`echo "(($int5_rx_bytes - $int5_orig_rx_bytes) * 0.00000762939453)  / $iterations / $time" | bc -l`
int6_rx_thrpt=`echo "(($int6_rx_bytes - $int6_orig_rx_bytes) * 0.00000762939453)  / $iterations / $time" | bc -l`

int1_tx_thrpt=`echo "(($int1_tx_bytes - $int1_orig_tx_bytes) * 0.00000762939453)  / $iterations / $time" | bc -l`
int2_tx_thrpt=`echo "(($int2_tx_bytes - $int2_orig_tx_bytes) * 0.00000762939453)  / $iterations / $time" | bc -l`
int3_tx_thrpt=`echo "(($int3_tx_bytes - $int3_orig_tx_bytes) * 0.00000762939453)  / $iterations / $time" | bc -l`
int4_tx_thrpt=`echo "(($int4_tx_bytes - $int4_orig_tx_bytes) * 0.00000762939453)  / $iterations / $time" | bc -l`
int5_tx_thrpt=`echo "(($int5_tx_bytes - $int5_orig_tx_bytes) * 0.00000762939453)  / $iterations / $time" | bc -l`
int6_tx_thrpt=`echo "(($int6_tx_bytes - $int6_orig_tx_bytes) * 0.00000762939453)  / $iterations / $time" | bc -l`

int1_bytes_total=`echo $int1_rx_thrpt + $int1_tx_thrpt | bc`
echo "Total average megabits per second (send and receive) for $int1 :" $int1_bytes_total

int2_bytes_total=`echo $int2_rx_thrpt + $int2_tx_thrpt | bc`
echo "Total average megabits per second (send and receive) for $int2 :" $int2_bytes_total

int3_bytes_total=`echo $int3_rx_thrpt + $int3_tx_thrpt | bc`
echo "Total average megabits per second (send and receive) for $int3 :" $int3_bytes_total

int4_bytes_total=`echo $int4_rx_thrpt + $int4_tx_thrpt | bc`
echo "Total average megabits per second (send and receive) for $int4 :" $int4_bytes_total

int5_bytes_total=`echo $int5_rx_thrpt + $int5_tx_thrpt | bc`
echo "Total average megabits per second (send and receive) for $int5 :" $int5_bytes_total

int6_bytes_total=`echo $int6_rx_thrpt + $int6_tx_thrpt | bc`
echo "Total average megabits per second (send and receive) for $int6 :" $int6_bytes_total

echo " "

total_agg_bytes=`echo $int1_bytes_total + $int2_bytes_total + $int3_bytes_total +$int4_bytes_total + $int5_bytes_total + $int6_bytes_total | bc -l`
echo "Total average aggregate megabits per second (send and receive):" $total_agg_bytes

