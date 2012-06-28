#!/bin/bash
# Written by Craig Dods

echo "Hello, please enter the correct log file to analyze"
ls
read logfile


echo " loop test time"
cat $logfile | awk '{print "route add -net",$1" netmask",$3" gw",$2}' $logfile | sh -x
