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


#Creates Host Nodes (/32)
grep "Host Node" $ORIG_FILE -A 1 -B 1 | awk -F[\>] '{print $3}' | sed 's/\<br//g;s/<\/a//g;s/<//g;/^\s*$/d' | awk '{printf "%s"(NR%2?" ":RS),$0}' | awk '{print "set security address-book global address",$1,$2}' > $HOSTS_OUT
#Creates networks and place in temp file for further parsing
grep -v $EXCLUDE  $ORIG_FILE |grep "Network"  -A 2 -B 1 | sed '/a\ href/d;/div/d;'| awk -F[\>] '{print $3}' | sed 's/\<br//g;s/<\/a//g;s/<//g;/^\s*$/d;s/\/td//g;/^$/d;/^M/d' | awk '{printf "%s"(NR%3?" ":RS),$0}' | grep -v "${BADCP}" | sed '/^M/d' > $TMP_NET
