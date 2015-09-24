#!/bin/bash

echo "Hello, we are now collecting the current routing information and generating SRX set commands"
echo ""

RTABLE=/var/tmp/RTABLE.txt
touch $RTABLE
FINAL=/var/tmp/Final_SRX_Configuration.jos
#Gathers table, deletes local + loopback routes
netstat -nr | grep -v "Kernel\|Destination" | awk '{ if ($2 != "0.0.0.0" ) { print $0; } }' | sed '/^\s*$/d' > $RTABLE

awk '{ if ($3 == "0.0.0.0" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/0 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "128.0.0.0" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/1 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "192.0.0.0" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/2 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "224.0.0.0" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/3 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "240.0.0.0" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/4 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "248.0.0.0" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/5 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "252.0.0.0" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/6 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "254.0.0.0" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/7 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "255.0.0.0" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/8 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "255.128.0.0" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/9 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "255.192.0.0" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/10 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "255.224.0.0" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/11 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "255.240.0.0" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/12 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "255.248.0.0" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/13 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "255.252.0.0" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/14 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "255.254.0.0" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/15 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "255.255.0.0" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/16 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "255.255.128.0" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/17 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "255.255.192.0" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/18 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "255.255.224.0" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/19 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "255.255.240.0" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/20 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "255.255.248.0" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/21 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "255.255.252.0" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/22 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "255.255.254.0" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/23 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "255.255.255.0" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/24 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "255.255.255.128" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/25 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "255.255.255.192" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/26 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "255.255.255.224" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/27 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "255.255.255.240" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/28 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "255.255.255.248" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/29 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "255.255.255.252" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/30 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "255.255.255.254" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/31 next-hop",$2}}' $RTABLE >> $FINAL
awk '{ if ($3 == "255.255.255.255" ) {print "set routing-instances TRAFFIC routing-options static route",$1"/32 next-hop",$2}}' $RTABLE >> $FINAL

echo "Please find your file at $FINAL"
rm $RTABLE
echo "Goodbye..."
