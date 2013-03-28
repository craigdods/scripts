#!/bin/bash
# Written by Craig Dods
# Last Edit on 03/28/2013
# This will attempt to pull networks, hosts, and services out a the simplified html dump
# Things this script will have issues with:
# Non UDP/TCP services (need XML vs html for this to work properly)
# Groups of any kind
# It is entirely dependent on the naming scheme of the exporter. If they called something 'udp-1512' but in reality it's 'tcp-1512', or if they're labelling hosts as "Net" something...you're screwed

# If you *really* need to do this properly, get XML

# May require fine tuning on the sed string to pull out all erroneous/error generating symbols on a per-policy basis.

echo "Hello, please enter the correct HTML file you'd like to parse:"
echo " "
ls | grep *.html 
read -s input_file
echo " "
echo "Thank you"
echo " "
time=`date +'%d%m%y_%H%M'`
logfile=$time\_$input_file\_parsed.txt
final=$time\_Parsed_HTML.dbedit

# Udp Services
echo "parsing UDP services..."
cat $input_file | grep service | grep -v 'FW1\|wap' | awk '{print $3,$4,$5}' |  sed 's/name\=\"//g;s/\<service\_//g;s/\">/ /g;s/<\/a>/ /g;s/<\/td>//g;s/<td//g;s/vAlign\=\"//g;s/ top //g;s/userdef-//g;s/userder//g;s/usserdef//g;s/href\=\"\#//g;/[0-9]/!d;/\;/d;s/^-//g;s/\ udp/\ udp\ /gI;' | awk '{print $1,$4,$5}' | grep -i udp | awk 'NF>=3' >> $logfile
echo "Done"

# TCP Services
echo " "
echo "parsing TCP services..."
cat $input_file | grep service | grep -v 'FW1\|wap' | awk '{print $3,$4,$5}' | sed 's/name\=\"//g;s/\<service\_//g;s/\">/ /g;s/<\/a>/ /g;s/<\/td>//g;s/<td//g;s/vAlign\=\"//g;s/ top //g;s/userdef-//g;s/userder//g;s/usserdef//g;s/href\=\"\#//g;/[0-9]/!d;/\;/d;s/^-//g;' | grep -i tcp | awk '{print $2,$3}' | sed 's/\ Tcp/\ tcp\ /g;s/^-//g' | awk 'NF>=3' >> $logfile
echo "Done"

# Network Hosts
echo " "
echo "parsing Network Hosts..."
cat $input_file | grep network_object | grep -v 'FW1\|wap\|group\|grp' | awk '{print $3,$4}' | awk 'NF>=2' | grep -v HP | sed 's/name="network_object_//g;s/\">/\ /g;s/<\/a><\/td><td//g;s/vAlign="top//g;s/network -//g;/[0-9]/!d' | grep -vi net | sed 's/ [^0-9]*/ /' | egrep '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}' | sed 's/ [^0-9]*/ /;s/ [^.]*-\([0-9][0-9.]*[0-9]\)/ \1/;s/ \([0-9][0-9.]*[0-9]\)[^0-9.].*$/ \1/' >> $logfile
echo "Done"

# Networks
echo " "
echo "parsing Networks..."
# Takes raw data and parses it as best we can without breaking anything, then dumps it into it's own separate file to be fixed $tmp_netfile
cat $input_file | grep network_object | grep -v 'FW1\|wap\|group\|grp' | awk '{print $3,$4}' | awk 'NF>=2' | grep -v HP | sed 's/name="network_object_//g;s/\">/\ /g;s/<\/a><\/td><td//g;s/vAlign="top//g;s/network -//g;/[0-9]/!d' | grep -i net | egrep '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}' | sed 's/ [^0-9]*/ /;'  | awk '{gsub(/[_-]/," ",$2)}1' >> $logfile
echo "Done"

echo " "
echo "Parsing complete"
echo "Creating dbedit commands now...may take some time"

#grep -v removes FW1 and global services - may need to tune depending on customer

# Creating tcp_service
cat $logfile | grep -v 'FW1\|'^g'' | grep " tcp " | awk '{print "create tcp_service",$1}' >> $final
cat $logfile | grep -v 'FW1\|'^g'' | grep " tcp " | awk '{print "modify services",$1" port",$3}' >> $final
cat $logfile | grep -v 'FW1\|'^g'' | grep " tcp " | awk '{print "update services",$1}' >> $final

# Creating udp_service
cat $logfile | grep -v 'FW1\|'^g'' | grep " udp " | awk '{print "create udp_service",$1}' >> $final
cat $logfile | grep -v 'FW1\|'^g'' | grep " udp " | awk '{print "modify services",$1" port",$3}' >> $final
cat $logfile | grep -v 'FW1\|'^g'' | grep " udp " | awk '{print "update services",$1}' >> $final

# Creating host_plain
cat $logfile | grep -vi " tcp \| udp \|net" | awk '{print "create host_plain",$1}' >> $final 
cat $logfile | grep -vi " tcp \| udp \|net" | awk '{print "modify network_objects",$1" ipaddr",$2}' >> $final
cat $logfile | grep -vi " tcp \| udp \|net" | awk '{print "update network_objects",$1}' >> $final

# Creating networks & associated subnet logic
cat $logfile | grep -i "net" | awk '{print "create network",$1}' >> $final
cat $logfile | grep -i "net" | awk '{print "modify network_objects",$1" ipaddr",$2}' >> $final

#And so begin the shenanigans of trying to create networks based off of network names. The default network creation with those without specifying masks is going to be /24 - change if required on the last awk 'else' line. Since HP's engineers can't type properly, /0/1/2 fields are assigned to /24 as well
cat -v $logfile | grep -i "net" | sed 's/\^M//g;s/[ \t]*$//' |awk '
$3==32{print "modify network_objects",$1" netmask 255.255.255.255"}
$3==31{print "modify network_objects",$1" netmask 255.255.255.254"}
$3==30{print "modify network_objects",$1" netmask 255.255.255.252"}
$3==29{print "modify network_objects",$1" netmask 255.255.255.248"}
$3==28{print "modify network_objects",$1" netmask 255.255.255.240"}
$3==27{print "modify network_objects",$1" netmask 255.255.255.224"}
$3==26{print "modify network_objects",$1" netmask 255.255.255.192"}
$3==25{print "modify network_objects",$1" netmask 255.255.255.128"}
$3==24{print "modify network_objects",$1" netmask 255.255.255.0"}
$3==23{print "modify network_objects",$1" netmask 255.255.254.0"}
$3==22{print "modify network_objects",$1" netmask 255.255.252.0"}
$3==21{print "modify network_objects",$1" netmask 255.255.248.0"}
$3==20{print "modify network_objects",$1" netmask 255.255.240.0"}
$3==19{print "modify network_objects",$1" netmask 255.255.224.0"}
$3==18{print "modify network_objects",$1" netmask 255.255.192.0"}
$3==17{print "modify network_objects",$1" netmask 255.255.128.0"}
$3==16{print "modify network_objects",$1" netmask 255.255.0.0"}
$3==15{print "modify network_objects",$1" netmask 255.254.0.0"}
$3==14{print "modify network_objects",$1" netmask 255.252.0.0"}
$3==13{print "modify network_objects",$1" netmask 255.248.0.0"}
$3==12{print "modify network_objects",$1" netmask 255.240.0.0"}
$3==11{print "modify network_objects",$1" netmask 255.224.0.0"}
$3==10{print "modify network_objects",$1" netmask 255.192.0.0"}
$3==9{print "modify network_objects",$1" netmask 255.128.0.0"}
$3==8{print "modify network_objects",$1" netmask 255.0.0.0"}
$3==2{print "modify network_objects",$1" netmask 255.255.255.0"}
$3==1{print "modify network_objects",$1" netmask 255.255.255.0"}
$3==0{print "modify network_objects",$1" netmask 255.255.255.0"}
!$3{print "modify network_objects",$1" netmask 255.255.255.0"}
' >> $final
cat $logfile | grep -i "net" | awk '{print "update network_objects",$1}' >> $final

line_count=`wc -l $final | awk '{print $1}'`
echo " "
echo "Cleaning up..."
rm $logfile
echo " "
echo "Finished - you have created" $line_count "dbedit commands"
echo " "
echo "The commands are found in" $final
echo " "
echo "Goodbye..."
echo " " 
