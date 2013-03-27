#!/bin/bash
# Written by Craig Dods
# Last Edit on 03/27/2013
# This will attempt to pull networks, hosts, and services out a the simplified html dump
# Things this script will have issues with:
# Non UDP/TCP services (need XML vs html for this to work properly)
# Groups of any kind
# It is entirely dependent on the naming scheme of the exporter. If they called something 'udp-1512' but in reality it's 'tcp-1512', or if they're labelling hosts as "Net" something...you're screwed

# If you *really* need to do this properly, get XML

# May require fine tuning on the sed string to pull out all erroneous/error generating symbols on a per-policy basis.

echo "Hello, please enter the correct HTML file you'd like to parse"
echo " "
ls | grep *.html 
read input_file
time=`date +'%d%m%y_%H%M%S'`
logfile=$time\_$input_file\_parsed.txt
tmp_netfile=temp_net_file.txt

# Udp Services
echo "parsing UDP services"
cat $input_file | grep service | grep -v 'FW1\|wap' | awk '{print $3,$4,$5}' |  sed 's/name\=\"//g;s/\<service\_//g;s/\">/ /g;s/<\/a>/ /g;s/<\/td>//g;s/<td//g;s/vAlign\=\"//g;s/ top //g;s/userdef-//g;s/userder//g;s/usserdef//g;s/href\=\"\#//g;/[0-9]/!d;/\;/d;s/^-//g;s/\ udp/\ udp\ /gI;' | awk '{print $1,$4,$5}' | grep -i udp | awk 'NF>=3' >> $logfile
echo "Done"
#### For Parsing -> Use | awk 'NF >1' | awk '{print $2}' on the logfile for UDP

# TCP Services
echo "parsing TCP services..."
cat $input_file | grep service | grep -v 'FW1\|wap' | awk '{print $3,$4,$5}' | sed 's/name\=\"//g;s/\<service\_//g;s/\">/ /g;s/<\/a>/ /g;s/<\/td>//g;s/<td//g;s/vAlign\=\"//g;s/ top //g;s/userdef-//g;s/userder//g;s/usserdef//g;s/href\=\"\#//g;/[0-9]/!d;/\;/d;s/^-//g;' | grep -i tcp | awk '{print $2,$3}' | sed 's/\ Tcp/\ tcp\ /g;s/^-//g' | awk 'NF>=3' >> $logfile
echo "Done"

# Network Hosts
echo "parsing Network Hosts..."
cat $input_file | grep network_object | grep -v 'FW1\|wap\|group\|grp' | awk '{print $3,$4}' | awk 'NF>=2' | grep -v HP | sed 's/name="network_object_//g;s/\">/\ /g;s/<\/a><\/td><td//g;s/vAlign="top//g;s/network -//g;/[0-9]/!d' | grep -vi net | sed 's/ [^0-9]*/ /' | egrep '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}' | sed 's/ [^0-9]*/ /;s/ [^.]*-\([0-9][0-9.]*[0-9]\)/ \1/;s/ \([0-9][0-9.]*[0-9]\)[^0-9.].*$/ \1/' >> $logfile
echo "Done"

# Networks
echo "parsing Networks..."
# Takes raw data and parses it as best we can without breaking anything, then dumps it into it's own separate file to be fixed $tmp_netfile
cat $input_file | grep network_object | grep -v 'FW1\|wap\|group\|grp' | awk '{print $3,$4}' | awk 'NF>=2' | grep -v HP | sed 's/name="network_object_//g;s/\">/\ /g;s/<\/a><\/td><td//g;s/vAlign="top//g;s/network -//g;/[0-9]/!d' | grep -i net | egrep '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}' | sed 's/ [^0-9]*/ /;'   >> $tmp_netfile
# Fix $tmp_netfile 
echo "Done"
