#!/bin/bash
# Written by Craig Dods

echo "Hello, please enter the correct log file to analyze"
ls | grep routes
read logfile

echo "Thank you - Reubilding the routing table now"

cat $logfile | awk '{print "clish -c \"set static-route",$1" nexthop gateway address",$2" on \""}' $logfile | sh
clish -c "save config"

echo "Finished rebuilding the routing table..."
echo " "
echo "Please remember to verify if the routes were rebuilt correctly!!"
echo "Goodbye "
