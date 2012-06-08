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
c_iter=$(( $iterations -1))


echo "There were" $c_iter "recordings $time minutes apart"


######## Packets per second

int1_pps_rx=`cat $logfile | grep $int1 | awk '{print $2}' | awk '{sum+=$1} END {printf "%f", sum}'`
int1_pps_tx=`cat $logfile | grep $int1 | awk '{print $10}' | awk '{sum+=$1} END {printf "%f", sum}'`
int1_orig_rx_pps=`cat $logfile | grep $int1 | head -n 1| sed s/"${int1}"//g | sed 's/[:]//g' |awk '{print$2}'`
int1_orig_tx_pps=`cat $logfile | grep $int1 | head -n 1| sed s/"${int1}"//g | sed 's/[:]//g' |awk '{print$10}'`
int1_rx_pps=`echo "($int1_pps_rx - $int1_orig_rx_pps)  / $c_iter / ($time * 60)" | bc`
int1_tx_pps=`echo "($int1_pps_tx - $int1_orig_tx_pps)  / $c_iter / ($time * 60)" | bc`


int2_pps_rx=`cat $logfile | grep $int2 | awk '{print $2}' | awk '{sum+=$1} END {printf "%f", sum}'`
int2_pps_tx=`cat $logfile | grep $int2 | awk '{print $10}' | awk '{sum+=$1} END {printf "%f", sum}'`
int2_orig_rx_pps=`cat $logfile | grep $int1 | head -n 1| sed s/"${int2}"//g | sed 's/[:]//g' |awk '{print$2}'`
int2_orig_tx_pps=`cat $logfile | grep $int1 | head -n 1| sed s/"${int2}"//g | sed 's/[:]//g' |awk '{print$10}'`
int2_rx_pps=`echo "($int2_pps_rx - $int2_orig_rx_pps)  / $c_iter / ($time * 60)" | bc`
int2_tx_pps=`echo "($int2_pps_tx - $int2_orig_tx_pps)  / $c_iter / ($time * 60)" | bc`

int3_pps_rx=`cat $logfile | grep $int3 | awk '{print $2}' | awk '{sum+=$1} END {printf "%f", sum}'`
int3_pps_tx=`cat $logfile | grep $int3 | awk '{print $10}' | awk '{sum+=$1} END {printf "%f", sum}'`
int3_orig_rx_pps=`cat $logfile | grep $int3 | head -n 1| sed s/"${int3}"//g | sed 's/[:]//g' |awk '{print$2}'`
int3_orig_tx_pps=`cat $logfile | grep $int3 | head -n 1| sed s/"${int3}"//g | sed 's/[:]//g' |awk '{print$10}'`
int3_rx_pps=`echo "($int3_pps_rx - $int3_orig_rx_pps)  / $c_iter / ($time * 60)" | bc`
int3_tx_pps=`echo "($int3_pps_tx - $int3_orig_tx_pps)  / $c_iter / ($time * 60)" | bc`

int4_pps_rx=`cat $logfile | grep $int4 | awk '{print $2}' | awk '{sum+=$1} END {printf "%f", sum}'`
int4_pps_tx=`cat $logfile | grep $int4 | awk '{print $10}' | awk '{sum+=$1} END {printf "%f", sum}'`
int4_orig_rx_pps=`cat $logfile | grep $int4 | head -n 1| sed s/"${int4}"//g | sed 's/[:]//g' |awk '{print$2}'`
int4_orig_tx_pps=`cat $logfile | grep $int4 | head -n 1| sed s/"${int4}"//g | sed 's/[:]//g' |awk '{print$10}'`
int4_rx_pps=`echo "($int4_pps_rx - $int4_orig_rx_pps)  / $c_iter / ($time * 60)" | bc`
int4_tx_pps=`echo "($int4_pps_tx - $int4_orig_tx_pps)  / $c_iter / ($time * 60)" | bc`


int5_pps_rx=`cat $logfile | grep $int5 | awk '{print $2}' | awk '{sum+=$1} END {printf "%f", sum}'`
int5_pps_tx=`cat $logfile | grep $int5 | awk '{print $10}' | awk '{sum+=$1} END {printf "%f", sum}'`
int5_orig_rx_pps=`cat $logfile | grep $int5 | head -n 1| sed s/"${int5}"//g | sed 's/[:]//g' |awk '{print$2}'`
int5_orig_tx_pps=`cat $logfile | grep $int5 | head -n 1| sed s/"${int5}"//g | sed 's/[:]//g' |awk '{print$10}'`
int5_rx_pps=`echo "($int5_pps_rx - $int5_orig_rx_pps)  / $c_iter / ($time * 60)" | bc`
int5_tx_pps=`echo "($int5_pps_tx - $int5_orig_tx_pps)  / $c_iter / ($time * 60)" | bc`


int6_pps_rx=`cat $logfile | grep $int6 | awk '{print $2}' | awk '{sum+=$1} END {printf "%f", sum}'`
int6_pps_tx=`cat $logfile | grep $int6 | awk '{print $10}' | awk '{sum+=$1} END {printf "%f", sum}'`
int6_orig_rx_pps=`cat $logfile | grep $int6 | head -n 1| sed s/"${int6}"//g | sed 's/[:]//g' |awk '{print$2}'`
int6_orig_tx_pps=`cat $logfile | grep $int6 | head -n 1| sed s/"${int6}"//g | sed 's/[:]//g' |awk '{print$10}'`
int6_rx_pps=`echo "($int6_pps_rx - $int6_orig_rx_pps)  / $c_iter / ($time * 60)" | bc`
int6_tx_pps=`echo "($int6_pps_tx - $int6_orig_tx_pps)  / $c_iter / ($time * 60)" | bc`


int1_pps_total=`echo $int1_rx_pps + $int1_tx_pps | bc`
echo "Total average" $int1 "packets per second (send and receive):" $int1_pps_total

int2_pps_total=`echo $int2_rx_pps + $int2_tx_pps | bc`
echo "Total average" $int2 "packets per second (send and receive):" $int2_pps_total

int3_pps_total=`echo $int3_rx_pps + $int3_tx_pps | bc`
echo "Total average" $int3 "packets per second (send and receive):" $int3_pps_total

int4_pps_total=`echo $int4_rx_pps + $int4_tx_pps | bc`
echo "Total average" $int4 "packets per second (send and receive):" $int4_pps_total

int5_pps_total=`echo $int5_rx_pps + $int5_tx_pps | bc`
echo "Total average" $int5 "packets per second (send and receive):" $int5_pps_total

int6_pps_total=`echo $int6_rx_pps + $int6_tx_pps | bc`
echo "Total average" $int6 "packets per second (send and receive):" $int6_pps_total

echo " "


total_agg_pps=`echo $int1_pps_total + $int2_pps_total + $int3_pps_total +$int4_pps_total + $int5_pps_total + $int6_pps_total | bc -l`
echo "Total average aggregate packets per second (send and receive):" $total_agg_pps
echo " "
echo " "

# Mbps section


#####THIS GETS FIRST COLUM BYTES
#int1_orig_rx_pps=`cat $logfile | grep $int1 | head -n 1| sed s/"${int1}"//g | sed 's/[:]//g' |awk '{print$1}'`

int1_bytes_rx=`cat $logfile | grep $int1 | sed s/"${int1}"//g | sed 's/[:]//g' | awk '{print $1}' | awk '{sum+=$1} END {printf "%f", sum}'`
int1_bytes_tx=`cat $logfile | grep $int1 | sed s/"${int1}"//g | sed 's/[:]//g' | awk '{print $9}' | awk '{sum+=$1} END {printf "%f", sum}'`
int1_orig_rx_bytes=`cat $logfile | grep $int1 | head -n 1| sed s/"${int1}"//g | sed 's/[:]//g' |awk '{print$1}'`
int1_orig_tx_bytes=`cat $logfile | grep $int1 | head -n 1| sed s/"${int1}"//g | sed 's/[:]//g' |awk '{print$9}'`
int1_rx_thrpt=`echo "(($int1_bytes_rx - $int1_orig_rx_bytes) * 0.00000762939453)  / $c_iter / ($time * 60)" | bc -l`
int1_tx_thrpt=`echo "(($int1_bytes_tx - $int1_orig_tx_bytes) * 0.00000762939453)  / $c_iter / ($time * 60)" | bc -l`

int2_bytes_rx=`cat $logfile | grep $int2 | sed s/"${int2}"//g | sed 's/[:]//g' | awk '{print $1}' | awk '{sum+=$1} END {printf "%f", sum}'`
int2_bytes_tx=`cat $logfile | grep $int2 | sed s/"${int2}"//g | sed 's/[:]//g' | awk '{print $9}' | awk '{sum+=$1} END {printf "%f", sum}'`
int2_orig_rx_bytes=`cat $logfile | grep $int2 | head -n 1| sed s/"${int2}"//g | sed 's/[:]//g' |awk '{print$1}'`
int2_orig_tx_bytes=`cat $logfile | grep $int2 | head -n 1| sed s/"${int2}"//g | sed 's/[:]//g' |awk '{print$9}'`
int2_rx_thrpt=`echo "(($int2_bytes_rx - $int2_orig_rx_bytes) * 0.00000762939453)  / $c_iter / ($time * 60)" | bc -l`
int2_tx_thrpt=`echo "(($int2_bytes_tx - $int2_orig_tx_bytes) * 0.00000762939453)  / $c_iter / ($time * 60)" | bc -l`

int3_bytes_rx=`cat $logfile | grep $int3 | sed s/"${int3}"//g | sed 's/[:]//g' | awk '{print $1}' | awk '{sum+=$1} END {printf "%f", sum}'`
int3_bytes_tx=`cat $logfile | grep $int3 | sed s/"${int3}"//g | sed 's/[:]//g' | awk '{print $9}' | awk '{sum+=$1} END {printf "%f", sum}'`
int3_orig_rx_bytes=`cat $logfile | grep $int3 | head -n 1| sed s/"${int3}"//g | sed 's/[:]//g' |awk '{print$1}'`
int3_orig_tx_bytes=`cat $logfile | grep $int3 | head -n 1| sed s/"${int3}"//g | sed 's/[:]//g' |awk '{print$9}'`
int3_rx_thrpt=`echo "(($int3_bytes_rx - $int3_orig_rx_bytes) * 0.00000762939453)  / $c_iter / ($time * 60)" | bc -l`
int3_tx_thrpt=`echo "(($int3_bytes_tx - $int3_orig_tx_bytes) * 0.00000762939453)  / $c_iter / ($time * 60)" | bc -l`

int4_bytes_rx=`cat $logfile | grep $int4 | sed s/"${int4}"//g | sed 's/[:]//g' | awk '{print $1}' | awk '{sum+=$1} END {printf "%f", sum}'`
int4_bytes_tx=`cat $logfile | grep $int4 | sed s/"${int4}"//g | sed 's/[:]//g' | awk '{print $9}' | awk '{sum+=$1} END {printf "%f", sum}'`
int4_orig_rx_bytes=`cat $logfile | grep $int4 | head -n 1| sed s/"${int4}"//g | sed 's/[:]//g' |awk '{print$1}'`
int4_orig_tx_bytes=`cat $logfile | grep $int4 | head -n 1| sed s/"${int4}"//g | sed 's/[:]//g' |awk '{print$9}'`
int4_rx_thrpt=`echo "(($int4_bytes_rx - $int4_orig_rx_bytes) * 0.00000762939453)  / $c_iter / ($time * 60)" | bc -l`
int4_tx_thrpt=`echo "(($int4_bytes_tx - $int4_orig_tx_bytes) * 0.00000762939453)  / $c_iter / ($time * 60)" | bc -l`

int5_bytes_rx=`cat $logfile | grep $int5 | sed s/"${int5}"//g | sed 's/[:]//g' | awk '{print $1}' | awk '{sum+=$1} END {printf "%f", sum}'`
int5_bytes_tx=`cat $logfile | grep $int5 | sed s/"${int5}"//g | sed 's/[:]//g' | awk '{print $9}' | awk '{sum+=$1} END {printf "%f", sum}'`
int5_orig_rx_bytes=`cat $logfile | grep $int5 | head -n 1| sed s/"${int5}"//g | sed 's/[:]//g' |awk '{print$1}'`
int5_orig_tx_bytes=`cat $logfile | grep $int5 | head -n 1| sed s/"${int5}"//g | sed 's/[:]//g' |awk '{print$9}'`
int5_rx_thrpt=`echo "(($int5_bytes_rx - $int5_orig_rx_bytes) * 0.00000762939453)  / $c_iter / ($time * 60)" | bc -l`
int5_tx_thrpt=`echo "(($int5_bytes_tx - $int5_orig_tx_bytes) * 0.00000762939453)  / $c_iter / ($time * 60)" | bc -l`


int6_bytes_rx=`cat $logfile | grep $int6 | sed s/"${int6}"//g | sed 's/[:]//g' | awk '{print $1}' | awk '{sum+=$1} END {printf "%f", sum}'`
int6_bytes_tx=`cat $logfile | grep $int6 | sed s/"${int6}"//g | sed 's/[:]//g' | awk '{print $9}' | awk '{sum+=$1} END {printf "%f", sum}'`
int6_orig_rx_bytes=`cat $logfile | grep $int6 | head -n 1| sed s/"${int6}"//g | sed 's/[:]//g' |awk '{print$1}'`
int6_orig_tx_bytes=`cat $logfile | grep $int6 | head -n 1| sed s/"${int6}"//g | sed 's/[:]//g' |awk '{print$9}'`
int6_rx_thrpt=`echo "(($int6_bytes_rx - $int6_orig_rx_bytes) * 0.00000762939453)  / $c_iter / ($time * 60)" | bc -l`
int6_tx_thrpt=`echo "(($int6_bytes_tx - $int6_orig_tx_bytes) * 0.00000762939453)  / $c_iter / ($time * 60)" | bc -l`

int1_bytes_total=`echo $int1_rx_thrpt + $int1_tx_thrpt | bc`
echo "Total average" $int1 "megabits per second (send and receive):" $int1_bytes_total

int2_bytes_total=`echo $int2_rx_thrpt + $int2_tx_thrpt | bc`
echo "Total average" $int2 "megabits per second (send and receive):" $int2_bytes_total

int3_bytes_total=`echo $int3_rx_thrpt + $int3_tx_thrpt | bc`
echo "Total average" $int3 "megabits per second (send and receive):" $int3_bytes_total

int4_bytes_total=`echo $int4_rx_thrpt + $int4_tx_thrpt | bc`
echo "Total average" $int4 "megabits per second (send and receive):" $int4_bytes_total

int5_bytes_total=`echo $int5_rx_thrpt + $int5_tx_thrpt | bc`
echo "Total average" $int5 "megabits per second (send and receive):" $int5_bytes_total

int6_bytes_total=`echo $int6_rx_thrpt + $int6_tx_thrpt | bc`
echo "Total average" $int6 "megabits per second (send and receive):" $int6_bytes_total

echo " "

total_agg_bytes=`echo $int1_bytes_total + $int2_bytes_total + $int3_bytes_total +$int4_bytes_total + $int5_bytes_total + $int6_bytes_total | bc -l`
echo "Total average aggregate megabits per second (send and receive):" $total_agg_bytes



