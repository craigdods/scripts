#!/bin/bash
# Written by Craig Dods
host=`hostname`
time=`date +'%d%m%y_%H%M%S'`
logfile=$time\_$host\_routes.txt

echo "Backing up routes now..."


echo " "

clish -c "show route" | grep "S   " | grep via | awk '{print $2,$4}' | sed 's/,//' >> $logfile

echo "DONE"
echo " "

echo "You can find your routes in" `pwd`\/$logfile

