#!/bin/bash
# Written by Craig Dods
# This does not currently function on:
# Firewalls with bridged interfaces (LACP)
# Firewalls with interfaces above eth9 (single placeholder right now '.')
# Not suggested for usage on VSX.

echo "Hello, please enter the correct log file to analyze"
ls | grep interfaces
read logfile

echo "Thank you - Recreating interfaces now"

#Modifying original output for ifconfig (logical interfaces '.' go to ':')
sed -i -r 's/^(eth[0-9]+)\./\1:/' $logfile

# Creating interfaces
cat $logfile | awk '{print "ifconfig",$1,$2" netmask",$3 }' | sh > /dev/null 2>&1
cat $logfile | awk '{print "ifconfig",$1" up"}' | sh

echo "Finished recreating the interfaces..."
echo " "
echo "Please remember to run ifconfig --save when finished!"
echo "Goodbye "
