#!/bin/bash
# Written by Craig Dods
# Last Edit on 04/01/2013
# This will attempt to pull networks, hosts, and services out a the simplified html dump
# Things this script will have issues with:
# Non UDP/TCP services (need XML vs html for this to work properly)
# Groups of any kind
# It is entirely dependent on the naming scheme of the exporter. If they called something 'udp-1512' but in reality it's 'tcp-1512', or if they're labelling hosts as "Net" something...you're screwed

# If you *really* need to do this properly, get XML

# May require fine tuning on the sed string to pull out all erroneous/error generating symbols on a per-policy basis.

echo "Hello, please enter the correct CSV file you'd like to parse:"
echo " "
ls | grep .csv 
read -s input_file
echo " "
echo "Thank you"
echo " "
time=`date +'%d%m%y_%H%M'`
#logfile=$time\_$input_file\_parsed.txt
final=Parsed_$input_file.dbedit

# Network Hosts
echo " "
echo "parsing and creating Network Hosts..."
# Creating host_plain
grep -v 'removed\|replaced\|redacted' $input_file | awk -F"[,|]" '{if ($2=="Host Node") print "create host_plain",$1}' >> $final 
grep -v 'removed\|replaced\|redacted' $input_file | awk -F"[,|]" '{if ($2=="Host Node") print "modify network_objects",$1" ipaddr",$3}' >> $final
grep -v 'removed\|replaced\|redacted' $input_file | awk -F"[,|]" '{if ($2=="Host Node") print "update network_objects",$1}' >> $final
echo "Done"

# Networks
echo " "
echo "parsing and creating Networks..."
grep -v 'removed\|replaced\|redacted' $input_file | awk -F"[,|]" '{if ($2=="Network") print "create network",$1}' >> $final
grep -v 'removed\|replaced\|redacted' $input_file | awk -F"[,|]" '{if ($2=="Network") print "modify network_objects",$1" ipaddr",$3}' >> $final
grep -v 'removed\|replaced\|redacted' $input_file | awk -F"[,|]" '{if ($2=="Network") print "modify network_objects",$1" netmask",$4}' >> $final
grep -v 'removed\|replaced\|redacted' $input_file | awk -F"[,|]" '{if ($2=="Network") print "update network_objects",$1}' >> $final
echo "Done"

# Udp Services
echo "parsing and creating UDP services..."
grep -v 'removed\|replaced\|redacted' $input_file | awk -F"[,|]" '{if ($2=="Udp") print "create udp_service",$1}' >> $final
grep -v 'removed\|replaced\|redacted' $input_file | awk -F"[,|]" '{if ($2=="Udp") print "modify services",$1" port",$3}' >> $final
grep -v 'removed\|replaced\|redacted' $input_file | awk -F"[,|]" '{if ($2=="Udp") print "update services",$1}' >> $final
echo "Done"

# TCP Services
echo " "
echo "parsing and creating TCP services..."
grep -v 'removed\|replaced\|redacted' $input_file | awk -F"[,|]" '{if ($2=="Tcp") print "create tcp_service",$1}' >> $final
grep -v 'removed\|replaced\|redacted' $input_file | awk -F"[,|]" '{if ($2=="Tcp") print "modify services",$1" port",$3}' >> $final
grep -v 'removed\|replaced\|redacted' $input_file | awk -F"[,|]" '{if ($2=="Tcp") print "update services",$1}' >> $final
echo "Done"



line_count=`wc -l $final | awk '{print $1}'`
echo " "
echo "Cleaning up..."
echo " "
echo "Finished - you have created" $line_count "dbedit commands"
echo " "
echo "The commands are found in" $final
echo " "
echo "Goodbye..."
echo " " 
