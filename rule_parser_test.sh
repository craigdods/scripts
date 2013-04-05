#!/bin/bash
# Written by Craig Dods
# Last Edit on 04/02/2013

input_file=usplsaplc004_03-06-13_scrubbed.csv

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
PName_col=$PolName\_scripted
PName=##$PolName\_scripted

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
#### IF TRAD
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

END {print curLine "\nupdate_all"}' $Rules | awk NF | sed 's/services:Any/globals:Any/g;s/network_objects:Any/globals:Any/g;s/accept_action:drop/drop_action:drop/g;s/network_objects:HP network - removed/network_objects:DUMMY_HOST_REMOVE/g;s/grp-eds/DUMMY_HOST_REMOVE/g;s/services:ISAKMP/services:IKE/g;s/ghttp/http/g;s/gftp/ftp/g;s/ws-domaincontroller-78.182/DUMMY_HOST_REMOVE/g;s/ws-ext-pacer-1.18/DUMMY_HOST_REMOVE/g;s/ws-ext-pacer-1.19/DUMMY_HOST_REMOVE/g;s/ws-ext-pacer-1.22/DUMMY_HOST_REMOVE/g;s/ws-ext-pacer-1.28/DUMMY_HOST_REMOVE/g;s/ws-ext-pacer-1.7/DUMMY_HOST_REMOVE/g;s/Eds_mail_relay_srvrs/DUMMY_HOST_REMOVE/g;s/EDS_GNOC_nets/DUMMY_HOST_REMOVE/g;s/EDS_EPCM_SRVR/DUMMY_HOST_REMOVE/g;s/EDS_NET_MGMT_NETS/DUMMY_HOST_REMOVE/g;s/g_OPSWARE_SVR_PL/DUMMY_HOST_REMOVE/g;s/NOL_hp_interconnect/DUMMY_HOST_REMOVE/g;s/NOL_hp_interconnect/DUMMY_HOST_REMOVE/g' >> $final_rules

# Here is where we do the automated cleanup to reduce manual effort:
grep "HP\ network - removed" $input_file | awk '{print $1}' | grep -vi ",,,,,,HP\|^HP\|,,HP\|^[0-9]\|Cluster\|Check" | awk -F, -v RFILE=$final_rules '{print "sed -i \x27s/"$1"/DUMMY_HOST_REMOVE/g\x27 "RFILE}' | sh
