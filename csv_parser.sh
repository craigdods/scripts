#!/bin/bash
# Written by Craig Dods
# Last Edit on 04/01/2013

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

bad_grep='removed\|replaced\|redacted\|FW1\|HackaTack\|MSN\|Napster\|Yahoo\|eDonkey\|CP_\|FIBMGR\|GNUtella\|KaZaA\|Kerberos\|MS-SQL\|NO.,NAME,SOURCE,DESTINATION'

# Network Hosts
echo " "
echo "parsing and creating Network Hosts..."
# Creating host_plain
grep -v $bad_grep $input_file | awk -F"[,|]" '{if ($2=="Host Node") print "create host_plain",$1}' >> $final 
grep -v $bad_grep $input_file | awk -F"[,|]" '{if ($2=="Host Node") print "modify network_objects",$1" ipaddr",$3}' >> $final
grep -v $bad_grep $input_file | awk -F"[,|]" '{if ($2=="Host Node") print "update network_objects",$1}' >> $final
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
grep -v $bad_grep $input_file | awk -F"[,|]" '{if ($2=="Udp") print "create udp_service",$1}' >> $final
grep -v $bad_grep $input_file | awk -F"[,|]" '{if ($2=="Udp") print "modify services",$1" port",$3}' >> $final
grep -v $bad_grep $input_file | awk -F"[,|]" '{if ($2=="Udp") print "update services",$1}' >> $final
echo "Done"

# TCP Services
echo " "
echo "parsing and creating TCP services..."
grep -v $bad_grep $input_file | awk -F"[,|]" '{if ($2=="Tcp") print "create tcp_service",$1}' >> $final
grep -v $bad_grep $input_file | awk -F"[,|]" '{if ($2=="Tcp") print "modify services",$1" port",$3}' >> $final
grep -v $bad_grep $input_file | awk -F"[,|]" '{if ($2=="Tcp") print "update services",$1}' >> $final
echo "Done"

# Creating Network_Object Groups
# Logic to separate services is not yet ready
grep -v $bad_grep $input_file | awk NF | awk -F, '$2=="Group"{ g=$1; print "create network_object_group",g } $7!="-"{print "addelement network_objects" g " \x27\x27 network_objects:" $7}' | grep -v "Add Any to\|add  to\|add Log to\|add Any to\|add None to\|add SERVICE\|add tcp50000\|add Members to" >> $final


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
