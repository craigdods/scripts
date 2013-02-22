#!/bin/bash
# Written by Craig Dods
# This does not currently function on:
# Firewalls with bridged interfaces (LACP)
# Firewalls with interfaces above eth9 (single placeholder right now '.'
# Not suggested for usage on VSX.

echo "Hello, please enter the correct log file to analyze"
ls | grep interfaces
read logfile

echo "Thank you - Recreating interfaces now"

#Modifying original output for ifconfig (logical interfaces '.' go to ':')
sed -i -r 's/^(eth[0-9]+)\./\1:/' $logfile

# First, we do the physical interfaces
cat $logfile | grep -v "eth.\:" | awk '{print "ifconfig",$1,$2" netmask",$3 }' | sh
cat $logfile | grep -v "eth.\:" | awk '{print "ifconfig",$1" up"}' | sh

# Now we do the tagged (VLAN) interfaces
#cat $logfile | grep "eth.\:" | awk '{print "ifconfig",$1,$2" netmask",$3 }




#cat $logfile | awk '{print "route add -net",$1" netmask",$3" gw",$2}' $logfile | sh > /dev/null 2>&1

echo "Finished recreating the interfaces..."
echo " "
echo "Please remember to run ifconfig --save when finished!"
echo "Goodbye "
