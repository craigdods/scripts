#!/bin/bash

echo "Hello, please enter the correct log file to analyze"
ls | grep CP-TP
read logfile

echo " "
echo $logfile "has been chosen"

cat $logfile | awk '
    BEGIN {
        OFMT = "%.4f"
    }

    /^[[:blank:]]*$/ { next }

    ! ($1 in prevrx) {
        prevrx[$1] = $2
        prevtx[$1] = $3
	next
        
    }
    {
        count[$1]++
        drx = $2 - prevrx[$1]
        dtx = $3 - prevtx[$1]
        rx[$1] += drx
        tx[$1] += dtx
        prevrx[$1] = $2
        prevtx[$1] = $3
    }
    END {
        for (iface in rx) {
            print iface, (rx[iface] / 131072 ) / count[iface], (tx[iface] / 131072) / count[iface]
        }
}'

