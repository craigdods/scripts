#!/bin/bash
# Written by Craig Dods
# This does not currently function on:
# Firewalls with bridged interfaces (LACP)
# Firewalls with interface numbers above eth9 
# Not suggested for usage on VSX.

echo "Hello, please enter the correct log file to analyze"
ls | grep interfaces
read logfile

echo "Thank you - Recreating interfaces now"

# Creating non-VLAN interfaces 
cat $logfile | grep -v "eth.\." | awk '{print "ifconfig",$1,$2" netmask",$3 }' | sh > /dev/null 2>&1
cat $logfile | grep -v "eth.\." | awk '{print "ifconfig",$1" up"}' | sh

# Creating VLAN'd interfaces
cat $logfile | grep "eth.\." | sed 's/\./ /g' | awk '{print "vconfig add",$1,$2}' | sh 
cat $logfile | grep "eth.\." | awk '{print "ifconfig",$1,$2" netmask",$3 }' | sh > /dev/null 2>&1
cat $logfile | grep "eth.\." | awk '{print "ifconfig",$1" up"}' | sh

echo "Finished recreating the interfaces..."
echo " "
echo "Please remember to run ifconfig --save when finished!"
echo "Goodbye "
