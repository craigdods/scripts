#!/bin/bash

### Static Configuration Statement
### Due to the limitations (inconsistencies, really) of CP Web Exports, there is not a reliable way to parse out Networks other than via grep. 
### As such, there exists the possibility of 'Groups' with 'Network' contained within the name being tagged
### As network objects. This can break the script. Please include problematic Groups that contain the word "Network" in the variable below ($Excluded_Groups)
### Format is as follows (Case sensitive)
### EXCLUDE='GroupANetwork\|GroupBNetworks\|GroupCNetwork\|GroupDNetworks'
###

EXCLUDE='US-587-Volcano-PGN-Networks\|Network-Telecom-scanners-LocalCMA\|Philips-Global-Networks-LocalCMA\|Philips-Global-Networks-Teletrol\|US-587-Volcano-Legacy-Networks\|US-587-Volcano-Networks\|LDAP-emi-USDANRMMD1'

###
### Removing Bad defaults from CP
BADCP="CP_SSL_Network_Extender\|Also used by\|Network Messenger UDP\|Microsoft Network Messenger\|Network File System Services\|RealNetworks RealPlayer\|Network File System Daemon\|Network Lock Manager Network\|Simple Network Management Protocol\|\^M\|\/TD"

echo "Hello, please select the CheckPoint Web Export you'd like to convert"
ls -lh
read -e -p "Enter:" ORIG_FILE

HOSTS_OUT=final_host_config.jos
touch $HOSTS_OUT

TMP_NET=/var/tmp/TMP_NET.txt
touch $TMP_NET
NETWORKS_OUT=final_network_config.jos
touch $NETWORKS_OUT

BADAPPS=applications_to_manually_create.txt
APPS_OUT=final_application_config.jos


#Creates Host Nodes (/32)
grep "Host Node" $ORIG_FILE -A 1 -B 1 | awk -F[\>] '{print $3}' | sed 's/\<br//g;s/<\/a//g;s/<//g;/^\s*$/d' | awk '{printf "%s"(NR%2?" ":RS),$0}' | awk '{print "set security address-book global address",$1,$2}' > $HOSTS_OUT
#Creates networks and place in temp file for further parsing
grep -v $EXCLUDE  $ORIG_FILE |grep "Network"  -A 2 -B 1 | sed '/a\ href/d;/div/d;'| awk -F[\>] '{print $3}' | sed 's/\<br//g;s/<\/a//g;s/<//g;/^\s*$/d;s/\/td//g;/^$/d' | awk '{printf "%s"(NR%3?" ":RS),$0}' | grep -v "${BADCP}" | sed 's/^M//g' > $TMP_NET

# Modify dotted quad addressing (x.x.x.x) to CIDR notation for Juniper
awk '{ if ($3 == "0.0.0.0" ) {print "set security address-book global address",$1,$2"/0" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "128.0.0.0" ) {print "set security address-book global address",$1,$2"/1" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "192.0.0.0" ) {print "set security address-book global address",$1,$2"/2" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "224.0.0.0" ) {print "set security address-book global address",$1,$2"/3" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "240.0.0.0" ) {print "set security address-book global address",$1,$2"/4" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "248.0.0.0" ) {print "set security address-book global address",$1,$2"/5" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "252.0.0.0" ) {print "set security address-book global address",$1,$2"/6" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "254.0.0.0" ) {print "set security address-book global address",$1,$2"/7" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "255.0.0.0" ) {print "set security address-book global address",$1,$2"/8" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "255.128.0.0" ) {print "set security address-book global address",$1,$2"/9" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "255.192.0.0" ) {print "set security address-book global address",$1,$2"/10" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "255.224.0.0" ) {print "set security address-book global address",$1,$2"/11" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "255.240.0.0" ) {print "set security address-book global address",$1,$2"/12" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "255.248.0.0" ) {print "set security address-book global address",$1,$2"/13" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "255.252.0.0" ) {print "set security address-book global address",$1,$2"/14" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "255.254.0.0" ) {print "set security address-book global address",$1,$2"/15" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "255.255.0.0" ) {print "set security address-book global address",$1,$2"/16" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "255.255.128.0" ) {print "set security address-book global address",$1,$2"/17" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "255.255.192.0" ) {print "set security address-book global address",$1,$2"/18" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "255.255.224.0" ) {print "set security address-book global address",$1,$2"/19" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "255.255.240.0" ) {print "set security address-book global address",$1,$2"/20" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "255.255.248.0" ) {print "set security address-book global address",$1,$2"/21" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "255.255.252.0" ) {print "set security address-book global address",$1,$2"/22" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "255.255.254.0" ) {print "set security address-book global address",$1,$2"/23" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "255.255.255.0" ) {print "set security address-book global address",$1,$2"/24" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "255.255.255.128" ) {print "set security address-book global address",$1,$2"/25" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "255.255.255.192" ) {print "set security address-book global address",$1,$2"/26" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "255.255.255.224" ) {print "set security address-book global address",$1,$2"/27" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "255.255.255.240" ) {print "set security address-book global address",$1,$2"/28" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "255.255.255.248" ) {print "set security address-book global address",$1,$2"/29" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "255.255.255.252" ) {print "set security address-book global address",$1,$2"/30" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "255.255.255.254" ) {print "set security address-book global address",$1,$2"/31" }}' $TMP_NET >> $NETWORKS_OUT
awk '{ if ($3 == "255.255.255.255" ) {print "set security address-book global address",$1,$2"/32" }}' $TMP_NET >> $NETWORKS_OUT

#Handling applications/services
# Identifying applications we are unable to handle due to poor information in Web Export
grep "service_" $ORIG_FILE -A 1 -B 1  | grep -v "a href\|div class\|\/div\|--\|\<br\>\|data_row" | grep -i "vAlign\|tcp\|udp" | sed 's/<td vAlign="top"><a name=//g;s/\/a//g;' | awk -F [\>] '{print $2,$5,$7}' | sed 's/<//g;s/\/td//g' | grep -i "dcerpc\|icmp\|group\|rpc\|other\|tcp_subservice\|multicast\|gtp\|tcp_citrix" > $BADAPPS

# Create applications that we do support
grep "service_" $ORIG_FILE -A 1 -B 1  | grep -v "a href\|div class\|\/div\|--\|\<br\>\|data_row" | grep -i "vAlign\|tcp\|udp" | sed 's/<td vAlign="top"><a name=//g;s/\/a//g;' | awk -F [\>] '{print $2,$5,$7}' | sed 's/<//g;s/\/td//g' | grep -iv "tcp-highports\|udp-high-ports\|dcerpc\|icmp\|group\|rpc\|other\|tcp_subservice\|multicast\|gtp\|tcp_citrix" | tr '[:upper:]' '[:lower:]' | awk '{print "set applications application",$1,"protocol",$2,"destination-port",$3}' > $APPS_OUT

# Create commonly used "custom" services such as high-ports
echo "set applications application tcp-high-ports protocol tcp destination-port 1024-65535" >> $APPS_OUT
echo "set applications application udp-high-ports protocol udp destination-port 1024-65535" >> $APPS_OUT
