#!/bin/bash
# Written by Craig Dods
host=`hostname`
time=`date +'%d%m%y_%H%M%S'`
logfile=$time\_$host\_routes.txt

echo "Backing up routes now..."


echo " "

netstat -nr | awk '{print $1,$2,$3}' | grep -v 'Kernel\|Destination' >> $logfile

echo "DONE"
echo " "

echo "You can find your routes in" `pwd`\/$logfile

