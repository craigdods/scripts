#!/bin/bash
#Script for parsing network objects and creating dbedit commands

echo "Hello, please enter the correct network objects file you wish to convert to dbedit"
ls | grep -v '.*.xml\|.*\.sh\|CKP\|.*.py\|ICA'
read logfile

echo "Thank you - creating dbedit commands now"

#DONT FORGET COLOR

#grep -v removes FW1 and global services - may need to tune depending on customer

# Creating tcp_service
cat $logfile | grep -v 'FW1\|'^g'' | grep tcp_service | awk '{print "create tcp_service",$1}'
cat $logfile | grep -v 'FW1\|'^g'' | grep tcp_service | awk '{print "modify services",$1" port",$3}' 
cat $logfile | grep -v 'FW1\|'^g'' | grep tcp_service | awk '{print "modify services",$1" color",$4,$5}' 
cat $logfile | grep -v 'FW1\|'^g'' | grep tcp_service | awk '{print "update services",$1}'

# Creating udp_service
cat $logfile | grep -v 'FW1\|'^g'' | grep udp_service | awk '{print "create udp_service",$1}'
cat $logfile | grep -v 'FW1\|'^g'' | grep udp_service | awk '{print "modify services",$1" port",$3}' 
cat $logfile | grep -v 'FW1\|'^g'' | grep udp_service | awk '{print "modify services",$1" color",$4,$5}' 
cat $logfile | grep -v 'FW1\|'^g'' | grep udp_service | awk '{print "update services",$1}'

