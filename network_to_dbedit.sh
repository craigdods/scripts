#!/bin/bash
#Script for parsing network objects and creating dbedit commands

echo "Hello, please enter the correct network objects file you wish to convert to dbedit"
ls | grep network
read logfile

echo "Thank you - creating dbedit commands now"

# Creating host_plain
cat $logfile | grep host_plain | awk '{print "create host_plain",$1}'
cat $logfile | grep host_plain | awk '{print "modify network_objects",$1" ipaddr",$3}' 
cat $logfile | grep host_plain | awk '{print "update network_objects",$1}'

# Creating network
cat $logfile | grep " network " | awk '{print "create network",$1}'
cat $logfile | grep " network " | awk '{print "modify network_objects",$1" ipaddr",$3}' 
cat $logfile | grep " network " | awk '{print "modify network_objects",$1" netmask",$4}' 
cat $logfile | grep " network " | awk '{print "update network_objects",$1}'

# Creating network_object_group



#cat $logfile | grep -v "eth.\." | awk '{print "ifconfig",$1,$2" netmask",$3 }' | sh > /dev/null 2>&1
#cat $logfile | grep -v "eth.\." | awk '{print "ifconfig",$1" up"}' | sh
