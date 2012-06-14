#!/bin/bash

echo "Hello, please enter the correct log file to analyze"
ls | grep CP-TP
read logfile

echo " "
echo $logfile "has been chosen"
echo " "
echo "All values are in mbps (megabits per second) "
echo "============================================"
echo "INT AVR_RX AVR_TX  MAX_RX  MAX_TX "

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
    if (drx > maxdrx[$1]) {
        maxdrx[$1] = drx
    }
    if (dtx > maxdtx[$1]) {
        maxdtx[$1] = dtx
    }
}
END {
    for (iface in rx) {
        print iface, (rx[iface] / 131072)  / count[iface], (tx[iface] / 131072) / count[iface], (maxdrx[iface] / 131072), (maxdtx[iface] / 131072)
    }
}'

