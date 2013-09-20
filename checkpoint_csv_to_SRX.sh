#!/bin/bash
# Written by Craig Dods
# Last Edit on 09/19/2013
# This will attempt to convert Check Point objects, exported from odumper, to Juniper SRX configuration
# Things to note:
# DCE-RPC defaults to ms-rpc. If you need to use sun-rpc, modify line 85 'ms-rpc' to 'sun-rpc'
# Nested Groups/Application-sets within other groups/sets may/maynot work correctly.
# Predefined Check Point services (MS-SQL) for instance will not carry over.

echo "Hello, please enter the correct csv file you'd like to parse:"
echo " "
ls | grep csv
read -s input_file
echo " "
echo "Thank you"
echo " "
time=`date +'%d%m%y_%H%M'`
temp_file=temp\_$input_file.txt
final=$time\_Parsed_CSV.config

# Cleanup from previous runs
touch $final

cp $input_file $temp_file

#Modify dotted-quad subnet mask to / notation for SRX
sed -i '
s/\<255\.255\.255\.255\>/\/32/g;
s/\<255\.255\.255\.254\>/\/31/g;
s/\<255\.255\.255\.252\>/\/30/g;
s/\<255\.255\.255\.248\>/\/29/g;
s/\<255\.255\.255\.240\>/\/28/g;
s/\<255\.255\.255\.224\>/\/27/g;
s/\<255\.255\.255\.192\>/\/26/g;
s/\<255\.255\.255\.128\>/\/25/g;
s/\<255\.255\.255\.0\>/\/24/g;
s/\<255\.255\.254\.0\>/\/23/g;
s/\<255\.255\.252\.0\>/\/22/g;
s/\<255\.255\.248\.0\>/\/21/g;
s/\<255\.255\.240\.0\>/\/20/g;
s/\<255\.255\.224\.0\>/\/19/g;
s/\<255\.255\.192\.0\>/\/18/g;
s/\<255\.255\.128\.0\>/\/17/g;
s/\<255\.255\.0\.0\>/\/16/g;
s/\<255\.254\.0\.0\>/\/15/g;
s/\<255\.252\.0\.0\>/\/14/g;
s/\<255\.248\.0\.0\>/\/13/g;
s/\<255\.240\.0\.0\>/\/12/g;
s/\<255\.224\.0\.0\>/\/11/g;
s/\<255\.192\.0\.0\>/\/10/g;
s/\<255\.128\.0\.0\>/\/9/g;
s/\<255\.0\.0\.0\>/\/8/g;
s/\<254\.0\.0\.0\>/\/7/g;
s/\<252\.0\.0\.0\>/\/6/g;
s/\<248\.0\.0\.0\>/\/5/g;
s/\<240\.0\.0\.0\>/\/4/g;
s/\<224\.0\.0\.0\>/\/3/g;
s/\<192\.0\.0\.0\>/\/2/g;
s/\<128\.0\.0\.0\>/\/1/g;
' $temp_file


# Create Address Book Entries
echo " "
echo "parsing and creating Address-Book Entries..."
# Creating hosts/networks (non-range)
awk -F "[,|]" '{if ($2=="host" || $2=="net") print "set security address-book global address",$1,$3$4}' $temp_file >> $final
# Creating range-address
awk -F "[,|]" '{if ($2=="range") print "set security address-book global address",$1,"range-address",$3,"to",$4}' $temp_file >> $final
echo "Done"

echo " "
echo "parsing and creating Address-Sets..."
# Creating Address-Sets
awk -F "[,|]" '{if ($2=="group") print "set security address-book global address-set",$1,"address",$3}' $temp_file >> $final
echo "Done"


echo " "
echo "parsing and creating Applications..."
# Creating TCP applications
awk -F "[,|]" '{if ($2=="tcp") print "set applications application",$1,"protocol tcp destination-port",$3}' $temp_file >> $final
# Creating UDP applications
awk -F "[,|]" '{if ($2=="udp") print "set applications application",$1,"protocol udp destination-port",$3}' $temp_file >> $final
# Creating DCE-RPC applications
awk -F "[,|]" '{if ($2=="dcerpc") print "set applications application",$1,"uuid",$3," application-protocol ms-rpc"}' $temp_file >> $final
echo "Done"

echo " "
echo "parsing and creating Application-Sets..."
# Creating S-Sets
awk -F "[,|]" '{if ($2=="srvgroup") print "set applications application-set",$1,"application",$3}' $temp_file >> $final
echo "Done"















#grep -v $bad_grep $input_file | awk -F"[,|]" '{if ($2=="Tcp" || $2=="tcp") print "create tcp_service",$1}' >> $final
