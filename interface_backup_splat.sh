#!/bin/bash
# Written by Craig Dods
host=`hostname`
time=`date +'%d%m%y_%H%M%S'`
logfile=$time\_$host\_interfaces.txt

echo "Backing up Checkpoint tagged interfaces now..."


echo " "
fw getifs | sed 's/localhost //g' >> $logfile
echo "DONE"
echo " "

echo "You can find your interfaces in" `pwd`\/$logfile
