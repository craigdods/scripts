#!/bin/bash

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
