#!/bin/bash
# Written by Craig Dods

echo "Hello, please enter the correct log file to analyze"
ls | grep routes
read logfile

echo "Thank you - Reubilding the routing table now"

cat $logfile | awk '{print "route add -net",$1" netmask",$3" gw",$2}' $logfile | sh > /dev/null 2>&1

echo "Finished rebuilding the routing table..."
echo " "
echo "Please remember to run route --save when finished!"
echo "Goodbye "
