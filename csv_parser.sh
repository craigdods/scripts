#!/bin/bash
# Written by Craig Dods
# Last Edit on 04/08/2013
# Service groups are currently non-functional due to the way CSV is created -> addelement requires separate types of objects (services vs network_objects), however it seems HP has added services into network groups (somehow...). For now, they do not work. 
# Manually edit out services from addelement before putting it into a CMA

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
final_rules=Rules_$input_file.dbedit
SG=ServiceGroups_to_pop_manually.txt
SpecialHosts=SpecialHosts.txt
Rules=tmp_rule_holder.txt

#Add known bad objects/services here
bad_grep="HackaTack\|MSN\|CP_[^0-9][^S]\|Kerberos\|NO.,NAME,SOURCE,DESTINATION\|HP[[:space:]]network\|ws-ext-pacer-1.7\|ws-ext-pacer-1.18\|ws-ext-pacer-1.22\|ws-ext-pacer-1.28\|ws-domaincontroller-78.182\|grp-eds"

#apl_155.130.0.0-155.130.135.211\|apl_155.130.135.213-155.130.255.255\

# Cleanup from previous runs
rm $final  
rm $SG 
#rm $SpecialHosts
#rm $Rules
#rm $final_rules

# Create Dummy Host to replace 'HP network - removed' if they used it in their hostnames...(consistency people!)
echo "create host_plain DUMMY_HOST_REMOVE" >> $final
echo "modify network_objects DUMMY_HOST_REMOVE ipaddr 1.1.1.1" >> $final
echo "update network_objects DUMMY_HOST_REMOVE" >> $final

# Special Case objects - VoIP Domains etc. Create manually - Request customer provide info regarding these 
# APL_VOIP_Dom:
Special_Hosts="APL_VOIP_Dom - VoIP Domain - No info provided"
echo "create host_plain APL_VOIP_Dom" >> $final
echo "modify network_objects APL_VOIP_Dom ipaddr 1.1.1.2" >> $final
echo "update network_objects APL_VOIP_Dom" >> $final

#These don't exist in CSV, and yet somehow they're part of rules...
echo "create tcp_service TCP-10565-10569" >> $final
echo "modify services TCP-10565-10569 port 10565-10569" >> $final
echo "update services TCP-10565-10569" >> $final
echo "create udp_service UDP-10565-10569" >> $final
echo "modify services UDP-10565-10569 port 10565-10569" >> $final
echo "update services UDP-10565-10569" >> $final
echo "create host_plain LHost_155.14.78.6" >> $final
echo "modify network_objects LHost_155.14.78.6 ipaddr 155.14.78.6" >> $final
echo "update network_objects LHost_155.14.78.6" >> $final
echo "create tcp_service g_tcp9990" >> $final
echo "modify services g_tcp9990 port 9990" >> $final
echo "update services g_tcp9990" >> $final
echo "create tcp_service g_tcp7774" >> $final
echo "modify services g_tcp7774 port 7774" >> $final
echo "update services g_tcp7774" >> $final
echo "create udp_service g_udp6665" >> $final
echo "modify services g_udp6665 port 6665" >> $final
echo "update services g_udp6665" >> $final



grep -v $bad_grep $input_file | awk -F"[,|]" '{if ($2=="Tcp" || $2=="tcp") print "create tcp_service",$1}' >> $final
grep -v $bad_grep $input_file | awk -F"[,|]" '{if ($2=="Tcp" || $2=="tcp") print "modify services",$1" port",$3}' >> $final
grep -v $bad_grep $input_file | awk -F"[,|]" '{if ($2=="Tcp" || $2=="tcp") print "update services",$1}' >> $final

echo $Special_Hosts >> $SpecialHosts

# Network Hosts 
echo " "
echo "parsing and creating Network Hosts..."
# Creating host_plain
grep -v $bad_grep $input_file | awk -F"[,|]" '{if ($2=="Host Node") print "create host_plain",$1}' >> $final 
grep -v $bad_grep $input_file | awk -F"[,|]" '{if ($2=="Host Node") print "modify network_objects",$1" ipaddr",$3}' >> $final
grep -v $bad_grep $input_file | awk -F"[,|]" '{if ($2=="Host Node") print "update network_objects",$1}' >> $final
echo "Done"

# Address Ranges
echo " "
echo "parsing and creating Address Ranges..."
grep -v $bad_grep $input_file | awk -F"[,|]" '{if ($2=="Address Range") print "create address_range",$1}' >> $final
grep -v $bad_grep $input_file | sed 's/,/\ /g' | awk '{if ($2=="Address" && $3=="Range")print "modify network_objects",$1" ipaddr_first",$4}' >> $final
grep -v $bad_grep $input_file | sed 's/,/\ /g' | awk '{if ($2=="Address" && $3=="Range")print "modify network_objects",$1" ipaddr_last",$6}' >> $final
grep -v $bad_grep $input_file | awk -F"[,|]" '{if ($2=="Address Range") print "update network_objects",$1}' >> $final
echo "Done"

# Networks
echo " "
echo "parsing and creating Networks..."
grep -v $bad_grep $input_file | awk -F"[,|]" '{if ($2=="Network") print "create network",$1}' >> $final
grep -v $bad_grep $input_file | awk -F"[,|]" '{if ($2=="Network") print "modify network_objects",$1" ipaddr",$3}' >> $final
grep -v $bad_grep $input_file | awk -F"[,|]" '{if ($2=="Network") print "modify network_objects",$1" netmask",$4}' >> $final
grep -v $bad_grep $input_file | awk -F"[,|]" '{if ($2=="Network") print "update network_objects",$1}' >> $final
echo "Done"

# Udp Services
echo "parsing and creating UDP services..."
grep -v $bad_grep $input_file | awk -F"[,|]" '{if ($2=="Udp" || $2=="udp") print "create udp_service",$1}' >> $final
grep -v $bad_grep $input_file | awk -F"[,|]" '{if ($2=="Udp" || $2=="udp") print "modify services",$1" port",$3}' >> $final
grep -v $bad_grep $input_file | awk -F"[,|]" '{if ($2=="Udp" || $2=="udp") print "update services",$1}' >> $final
echo "Done"

# TCP Services
echo " "
echo "parsing and creating TCP services..."
grep -v $bad_grep $input_file | awk -F"[,|]" '{if ($2=="Tcp" || $2=="tcp") print "create tcp_service",$1}' >> $final
grep -v $bad_grep $input_file | awk -F"[,|]" '{if ($2=="Tcp" || $2=="tcp") print "modify services",$1" port",$3}' >> $final
grep -v $bad_grep $input_file | awk -F"[,|]" '{if ($2=="Tcp" || $2=="tcp") print "update services",$1}' >> $final
echo "Done"

# Creating empty Service groups
echo " "
echo "parsing and creating EMPTY Service Groups - You will have to populate these on your own"
grep -v $bad_grep $input_file | grep group | grep 'sg-\|Gem\|printing_group\|Port\|Ports\|ports\|PORTS\|service\|SERVICE\|ICMP\|icmp\|TCP\|tcp\|UDP\|udp\|TERADATA\|SVC\|MQ' | awk -F, '{print "create service_group " $1}' >> $final
grep -v $bad_grep $input_file | grep group | grep 'sg-\|Gem\|printing_group\|Port\|Ports\|ports\|PORTS\|service\|SERVICE\|ICMP\|icmp\|TCP\|tcp\|UDP\|udp\|TERADATA\|SVC\|MQ' | awk -F, '{print "update services " $1}' >> $final
grep -v $bad_grep $input_file | grep group | grep 'sg-\|Gem\|printing_group\|Port\|Ports\|ports\|PORTS\|service\|SERVICE\|ICMP\|icmp\|TCP\|tcp\|UDP\|udp\|TERADATA\|SVC\|MQ' | awk -F, '{print $1}' >> $SG
echo "Done"

# Creating Network_Object Groups

grep -v $bad_grep $input_file | awk NF | awk -F, '$2=="Group"{ g=$1; print "create network_object_group",g "\nupdate network_objects",g } $7!="-" && $7!=""&& $7!="Log" && $7!="Any"{print "addelement network_objects " g " \x27\x27 network_objects:" $7 "\nupdate network_objects",g}' | grep -vi 'udp/tcp'>> $final

grep -v $bad_grep $input_file | awk NF | awk -F, '$2=="Group"{ g=$1; print "update network_objects",g }' >> $final

# Complicated rule creation section
# Determine policy name:
#Rules=tmp_rule_holder.txt
#Extract the rulebase from the original CSV to ease parsing:
#cat $input_file | sed -n '/Security Policy:/,/Top of table/p' | grep -v "Top of table" >> $Rules

#PolName=`grep "Security Policy:" $Rules | awk -F, '{print $1}' | awk '{print $3}'`
#PName_col=$PolName\_scripted
#PName=##$PolName\_scripted

#Create the new rulebase and default rule0
#echo "create policies_collection" $PName_col
#echo "update policies_collections" $PName
#echo "create firewall_policy" $PName
#echo "modify fw_policies" $PName "collection policies_collections:"$PName_col
#echo "addelement fw_policies" $PName "rule security_header_rule"
#echo "addelement fw_policies" $PName "rule:0:action drop_action:drop"


line_count=`wc -l $final | awk '{print $1}'`
echo " "
echo "Cleaning up..."
echo " "
echo "Finished - you have created" $line_count "dbedit commands"
echo " "
echo "The commands are found in" $final
echo " "
echo "The Service Groups you need to populate manually are found in" $SG
echo " "
echo "Special hosts that need further information provided from HP are found in" $SpecialHosts
echo " "
echo "Goodbye..."
echo " " 
