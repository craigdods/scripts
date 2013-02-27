#!/bin/bash
# Written by Craig Dods
host=`hostname`
time=`date +'%d%m%y_%H%M%S'`
logfile=$time\_$host\_interfaces.txt

echo "Backing up Checkpoint tagged interfaces now..."


echo " "
ifconfig -a | grep eth -A 1 | awk '{print $1,$2,$4}' | sed 's/Link HWaddr//g;s/inet addr\://g;s/Mask\://g;s/\-\-//g;/^$/ d' | grep -v 'UP\|^ ' | tr -d '\n' | sed 's/eth/\neth/g' | awk 'NF>1' >> $logfile
echo "DONE"
echo " "

echo "You can find your interfaces in" `pwd`\/$logfile

