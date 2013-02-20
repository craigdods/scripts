#!/bin/bash

X=55000
table_size=`fw tab -s | grep fwx_alloc | awk '{print $4}'`
LOGFILE=/var/log/nat_table
DATE=`/bin/date -u`
touch $LOGFILE

if [ "$X" -lt "$table_size" ]
then
echo $DATE >> $LOGFILE
echo "****NAT Table Limit Exceeded!*****" >> $LOGFILE
echo "Current Table Size:" >> $LOGFILE
echo $table_size >> $LOGFILE
fi
