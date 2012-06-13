#!/bin/bash

echo "Hello, please enter the correct log file to analyze"
ls | grep CP-TP
read logfile

echo " "
echo $logfile "has been chosen"

cat $logfile | awk '
NR == 1 {
    baserx = $2
    basetx = $3
}
{
    rx[$1] += $2 - baserx 
    tx[$1] += $3 - basetx
}
END {
    for (iface in rx) {
        print iface, (rx[iface] / 131072) / NR, (tx[iface] / 131072) / NR
    }
}'


