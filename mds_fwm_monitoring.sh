#!/bin/bash
# Script for monitoring & restarting MDS' FWM should it crash

. /etc/profile.d/CP.sh

time=`date +'%m%d%H%M%S'`
MDS_STATUS=`mdsstat | grep MDS | awk '{print $8}'`
$logfile=/var/home/craigd/mds_fwm_status.txt

touch $logfile

if [ $MDS_STATUS = down ]
	then
		mdsstop -m
		sleep 5
		mdsstart -m
		echo "The MDS was restarted at " $time >> $logfile 
	fi
