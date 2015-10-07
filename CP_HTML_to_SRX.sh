#!/bin/bash

#Creates Host Nodes (/32)
grep "Host Node" $INPUT_FILE -A 1 -B 1 | awk -F[\>] '{print $3}' | sed 's/\<br//g;s/<\/a//g;s/<//g;/^\s*$/d' | awk '{printf "%s"(NR%2?" ":RS),$0}' | awk '{print "set security address-book global address",$1,$2}'
#Creates networks
grep -v "US-587-Volcano-PGN-Networks\|Network-Telecom-scanners-LocalCMA\|Philips-Global-Networks-LocalCMA\|Philips-Global-Networks-Teletrol\|US-587-Volcano-Legacy-Networks\|US-587-Volcano-Networks" Cambridge.html|grep "Network"  -A 2 -B 1 | sed '/a\ href/d;/div/d;'| awk -F[\>] '{print $3}' | sed 's/\<br//g;s/<\/a//g;s/<//g;/^\s*$/d;s/\/td//g;/^$/d' | awk '{printf "%s"(NR%3?" ":RS),$0}'
