#!/bin/bash
# Written by Craig Dods
# Last Edit on 04/02/2013
# Example:

#create policies_collection mypolicy
#update policies_collections mypolicy
#create firewall_policy ##mypolicy
#modify fw_policies ##mypolicy collection policies_collections:mypolicy
#addelement fw_policies ##mypolicy rule security_header_rule
#addelement fw_policies ##mypolicy rule:0:action drop_action:drop

#addelement fw_policies ##mypolicy rule security_rule
#addelement fw_policies ##mypolicy rule:1:action accept_action:accept
#modify fw_policies ##mypolicy rule:1:comments "Allow IKE between all firewalls"
#addelement fw_policies ##mypolicy rule:1:services:'' services:IKE
#addelement fw_policies ##mypolicy rule:1:src:'' network_objects:APL_155.14.133.11
#addelement fw_policies ##mypolicy rule:1:dst:'' network_objects:APL_155.14.133.13
#rmelement fw_policies ##mypolicy rule:1:track: tracks:None
#addelement fw_policies ##mypolicy rule:1:track: tracks:Log
#update fw_policies ##mypolicy

input_file=usdlsapli001_03-06-13_scrubbed.csv

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

#Cleaning up previous run
rm tmp_rule_holder.txt

# Complicated rule creation section
# Determine policy name:
Rules=tmp_rule_holder.txt
#Extract the rulebase from the original CSV to ease parsing:
cat $input_file | sed -n '/Security Policy:/,/Top of table/p' | grep -v "Top of table\|SOURCE,DESTINATION\|rulebase" >> $Rules

PolName=`grep "Security Policy:" $Rules | awk -F, '{print $1}' | awk '{print $3}'`
PName_col=$PolName\_scripted
PName=##$PolName\_scripted
#Takes Unscrubbed policy (HP exports with global policy) - rules start with 12 or higher - need to adjust for dbedit to work
#Will subtract the number in $1 by $Starting_Rule to give it the correct number. So rule #12 becomes #1, #13 becomes #2, etc. 
Starting_Rule=`awk -F, 'NR==2 {print $1 -1 }' $Rules`

#Create the new rulebase and default rule0
echo "update_all"
echo "create policies_collection" $PName_col
echo "update policies_collections" $PName_col
echo "create firewall_policy" $PName
echo "modify fw_policies" $PName "collection policies_collections:"$PName_col
echo "addelement fw_policies" $PName "rule security_header_rule"
echo "addelement fw_policies" $PName "rule:0:action drop_action:drop"
echo "modify fw_policies" $PName "rule:0:disabled true"
echo "update_all"
# Parse & Create rules
#$1 = Rule number
#$3 = Source
#$4 = Destination
#$5 = Service
#$6 = Action
#$7 = Track
#$10 = Comments
#cat $Rules | awk -v PN=$PName -F, '{print PN}'

# Determine rule number:
Real_RuleNumber=`awk -F, '$1 ~ "^[0-9]*$" {print $1}' $Rules`
echo $Real_RuleNumber
