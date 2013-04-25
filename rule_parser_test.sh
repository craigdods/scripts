#!/bin/bash
# Written by Craig Dods
# Last Edit on 04/08/2013

input_file=usplsapls007_041613_scrubbed.csv

#echo "Hello, please enter the correct CSV file you'd like to parse:"
#echo " "
#ls | grep .csv 
#read -s input_file
#echo " "
#echo "Thank you"
#echo " "
time=`date +'%d%m%y_%H%M'`
#logfile=$time\_$input_file\_parsed.txt
final=Parsed_$input_file.dbedit
final_rules=Rules_$input_file.dbedit

#Cleaning up previous run
rm tmp_rule_holder.txt
rm $final_rules

# Rule creation section
# Determine policy name:
Rules=tmp_rule_holder.txt
#Extract the rulebase from the original CSV to ease parsing:
cat $input_file | sed -n '/Security Policy:/,/Top of table/p' | grep -v "Top of table\|SOURCE,DESTINATION\|rulebase\|Security Policy:" >> $Rules


PolName=`grep "Security Policy:" $input_file | awk -F, '{print $1}' | awk '{print $3}'`
PName_col=$PolName\_sc
PName=##$PolName\_sc

#Create the new rulebase and default rule0
echo "update_all" >> $final_rules
echo "create policies_collection" $PName_col >> $final_rules
echo "update policies_collections" $PName_col >> $final_rules
echo "create firewall_policy" $PName >> $final_rules
echo "modify fw_policies" $PName "collection policies_collections:"$PName_col >> $final_rules
echo "addelement fw_policies" $PName "rule security_header_rule" >> $final_rules
echo "addelement fw_policies" $PName "rule:0:action drop_action:drop" >> $final_rules
echo "modify fw_policies" $PName "rule:0:disabled true" >> $final_rules
# Parse & Create rules
#$1 = Rule number
#$3 = Source
#$4 = Destination
#### IF SIMPLIFIED - NEED TO MODIFY
#$6 = Service
#$7 = Action
#$8 = Track
#$11 = Comments
#### IF TRADITIONAL
#$5 = Service
#$6 = Action
#$7 = Track
#$10 = Comments
#cat $Rules | awk -v PN=$PName -F, '{print PN}'

awk -v PN=$PName 'BEGIN{
    FS=",";recNum=0;curLine=""
}

$1!="" {
    print curLine,"\n"
    recNum++;
    $1=recNum;

    curLine=sprintf("update_all\naddelement fw_policies " PN " rule security_rule\naddelement fw_policies " PN " rule:"$1":action accept_action:"$7);
    curLine=curLine sprintf("\nmodify fw_policies " PN " rule:"$1":comments \""$11"\"""\n");
    curLine=curLine sprintf("\nrmelement fw_policies " PN " rule:"$1":track: tracks:None""\n");
    curLine=curLine sprintf("\naddelement fw_policies " PN " rule:"$1":track: tracks:Log""\n");
}
$1=="" {
    $1=recNum;
}

$3!=""{
    curLine=curLine sprintf("addelement fw_policies " PN " rule:"$1":src:\x27\x27 network_objects:"$3"\n");
}
$4!=""{
    curLine=curLine sprintf("addelement fw_policies " PN " rule:"$1":dst:\x27\x27 network_objects:"$4"\n");
}
$6!=""{
    curLine=curLine sprintf("addelement fw_policies " PN " rule:"$1":services:\x27\x27 services:"$6"\n");    
}

END {print curLine "\nupdate_all"}' $Rules | awk NF | sed 's/services:Any/globals:Any/g;
s/network_objects:Any/globals:Any/g;
s/accept_action:drop/drop_action:drop/g;
s/network_objects:HP network - removed/network_objects:DUMMY_HOST_REMOVE/g;
s/grp-eds/DUMMY_HOST_REMOVE/g;
s/services:ISAKMP/services:IKE/g;
s/ghttp/http/g;
s/gftp/ftp/g;
s/ws-domaincontroller-78.182/DUMMY_HOST_REMOVE/g;
s/ws-ext-pacer-1.18/DUMMY_HOST_REMOVE/g;
s/ws-ext-pacer-1.19/DUMMY_HOST_REMOVE/g;
s/ws-ext-pacer-1.22/DUMMY_HOST_REMOVE/g;
s/ws-ext-pacer-1.28/DUMMY_HOST_REMOVE/g;
s/ws-ext-pacer-1.7/DUMMY_HOST_REMOVE/g;
s/Eds_mail_relay_srvrs/DUMMY_HOST_REMOVE/g;
s/EDS_GNOC_nets/DUMMY_HOST_REMOVE/g;
s/EDS_EPCM_SRVR/DUMMY_HOST_REMOVE/g;s/EDS_NET_MGMT_NETS/DUMMY_HOST_REMOVE/g;
s/g_OPSWARE_SVR_PL/DUMMY_HOST_REMOVE/g;s/NOL_hp_interconnect/DUMMY_HOST_REMOVE/g;
s/NOL_hp_interconnect/DUMMY_HOST_REMOVE/g;
s/\<IBM_172.17.232.13\>/DUMMY_HOST_REMOVE/g;
s/INAT_172.17.220.189/DUMMY_HOST_REMOVE/g;
s/ext_HP network - removed/DUMMY_HOST_REMOVE/g;
s/GLOBALfirewall/DUMMY_HOST_REMOVE/g;
s/aplp001_cluster/DUMMY_HOST_REMOVE/g;
s/echo-dest-unreachabe/dest-unreach/g;
s/echo-time-exceed/time-exceeded/g;
s/ext_net_60.90.128.0_26/Ext_net_60.90.128.0_26/g;
s/Apl_155.14.64.15/apl_155.14.64.15/g;
s/apl_155.14.94.219/APL_155.14.94.219/g;
s/Apl_155.14.30.87/apl_155.14.30.87/g;
s/APLM_mgt/DUMMY_HOST_REMOVE/g;
s/APL_155.14.78.27/apl_155.14.78.27/g;
s/APL_155.14.78.69/apl_155.14.78.69/g;
s/APL_155.14.64.68/apl_155.14.64.68/g;
s/APL_155.14.64.78/apl_155.14.64.78/g;
s/gssh/ssh/g;
s/MAV_servers/MAV_Servers/g;
s/APL_172.17.71.105/Apl_172.17.71.105/g;
s/APL_172.17.71.106/Apl_172.17.71.106/g;
s/HP Network - removed/DUMMY_HOST_REMOVE/g;
s/Dev005_Cluster/DUMMY_HOST_REMOVE/g;
s/Tommy_Hilfiger_194.178.225.226/tommy_hilfiger_194.178.225.226/g;
s/Meridian_IQ/MERIDIAN_IQ/g;
s/ngc_164.235.139.150/NGC_164.235.139.150/g;
s/ngc_164.235.43.150/NGC_164.235.43.150/g;
s/ws-ext-nike-202.180/Ws-ext-nike-202.180/g;
s/lowes_168.244.164.33/Lowes_168.244.164.33/g;
s/apl_172.17.65.15/APL_172.17.65.15/g;
s/Dest_Quest/Dest_quest/g;
s/Dest_Quest_NAT/Dest_quest_NAT/g;
s/Apl_155.14.78.27/apl_155.14.78.27/g;
s/Apl_155.14.78.55/apl_155.14.78.55/g;
s/Apl_155.14.78.79/apl_155.14.78.79/g;
s/Apl_155.14.78.69/apl_155.14.78.69/g;
s/apl_155.14.245.66/APL_155.14.245.66/g;
s/apl_155.14.94.216/APL_155.14.94.216/g;
s/apl_155.14.94.218/APL_155.14.94.218/g;
s/apl_155.14.94.217/APL_155.14.94.217/g;
s/manhattan_vpn_63.167.13.200/Manhattan_vpn_63.167.13.200/g;
s/Apl_155.14.80.179/apl_155.14.80.179/g;
s/apl_net_192.168.155.16_31/Apl_net_192.168.155.16_31/g;
s/apl_eds_tng_srvr_net/Apl_eds_tng_srvr_net/g;
s/net_155.14.64.0_24/Net_155.14.64.0_24/g;
s/apl_as400_nets/Apl_as400_nets/g;
s/apl_155.14.64.231/Apl_155.14.64.231/g;
s/gsnmp-trap/snmp-trap/g;
s/apl_155.14.94.221/APL_155.14.94.221/g;
s/wct_216.117.102.231/WCT_216.117.102.231/g;
s/Codelab_209.104.252.243/codelab_209.104.252.243/g;
s/apl_172.17.68.1/Apl_172.17.68.1/g;
s/Apl_172.17.68.12/apl_172.17.68.12/g;
s/AV_Clients/AV_CLIENTS/g;
s/NOL_TIVOLI_CANDLE_DESt/NOL_TIVOLI_CANDLE_DEST/g;
s/\<gdomain-udp\>/domain-udp/g;
s/\<NET_192.168.154.0_27\>/Net_192.168.154.0_27/g;
s/\<NET_192.168.154.64_27\>/Net_192.168.154.64_27/g;
s/\<APL_NET_192.168.154.0_25\>/apl_net_192.168.154.0_25/g;
s/\<NET_192.168.154.32_27\>/Net_192.168.154.32_27/g' >> $final_rules 

# Here is where we do the automated cleanup to reduce manual effort:
grep "HP\ network - removed\|HP network -removed\|HP Network - removed" $input_file | awk '{print $1}' | grep -v ",,,,,,HP\|^HP\|,,HP\|^[0-9]\|Cluster\|Check\|,,ext_HP\|,,apl_net_10.6.2.0_25,HP" | awk -F, -v RFILE=$final_rules '{print "sed -i \x27s/"$1"/DUMMY_HOST_REMOVE/g\x27 "RFILE}' | sh

rm -rf sed*
