#!/bin/bash
# Written by Craig Dods

echo "Hello, please enter the correct log file to analyze"
ls | grep routes
read logfile


echo " loop test time"
cat $logfile | awk '{print "route add -net",$1" netmask",$3" gw",$2}' $logfile | sh -x

echo "COMPLETED"
echo " "
echo "Please remember to run route --save when finished!"
echo "Goodbye "
