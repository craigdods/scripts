#!/bin/bash
# Written by Craig Dods
# Last Edit on 04/02/2013
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

bad_grep="FW1\|HackaTack\|MSN\|CP_\|FIBMGR\|Kerberos\|MS-SQL\|NO.,NAME,SOURCE,DESTINATION\|HP[[:space:]]network"

# Cleanup from previous runs
rm $final

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
# If additional services get pulled in, just add it to the grep -v string at the end

grep -v $bad_grep $input_file | awk NF | awk -F, '$2=="Group"{ g=$1; print "create network_object_group",g } $7!="-" && $7!=""&& $7!="Log" && $7!="Any"{print "addelement network_objects " g " \x27\x27 network_objects:" $7}' | grep -vi 'udp/tcp'>> $final
# Only use if networks/objects don't use service names in them (like smtp-servers, ftp-servers, etc - HP does, have to manually edit...)
#grep -v $bad_grep $input_file | awk NF | awk -F, '$2=="Group"{ g=$1; print "create network_object_group",g } $7!="-" && $7!=""&& $7!="Log" && $7!="Any"{print "addelement network_objects " g " \x27\x27 network_objects:" $7}' | grep -v 'tcp\|udp\|Tcp\|Udp\|AH\|AOL\|archie\|Backage\|Bionet-Setup\|Blubster\|Citrix_ICA\|Citrix_ICA_Browsing\|CPD\|CrackDown\|DaCryptic\|DerSphere\|DerSphere_II\|dest-unreach\|echo-reply\|echo-request\|Entrust-Admin\|Entrust-KeyMgmt\|ESP\|Freak2k\|FreeTel-outgoing-client\|FreeTel-outgoing-server\|ftp\|ftp-bidir\|ftp-data\|ftp-pasv\|ftp-port\|FW1\|FW1_clntauth_http\|FW1_clntauth_telnet\|FW1_ica_pull\|FW1_key\|FW1_log\|FW1_mgmt\|GateCrasher\|gftp\|ghttp\|gopher\|GoToMyPC\|gre\|H323\|HackaTack_31785\|HackaTack_31787\|HackaTack_31788\|HackaTack_31789\|HackaTack_31790\|HackaTack_31791\|HackaTack_31792\|Hotline_client\|Hotline_tracker\|http\|https\|HTTP_wo_SCV\|ICKiller\|icmp-proto\|ICQ_locator\|IKE\|imap\|iMesh\|InCommand\|info-reply\|info-req\|irc1\|irc2\|ISAKMP\|Jade\|Kaos\|Kuang2\|ldap\|ldap-ssl\|login\|lpdw0rm\|Madster\|mask-reply\|mask-request\|Mneah\|mountd\|MSExchangeADL\|MSExchangeDirRef\|MSExchangeDirRep\|MSExchangeDirSync\|MSExchangeDS\|MSExchangeDSNSPI\|MSExchangeDSRep\|MSExchangeDSXDS\|MSExchangeIS\|MSExchangeMTA\|MSExchangeRA\|MSExchangeStoreAdm\|MSExchangeSysAtt\|MSExchangeSysAttPriv\|MSN_Messenger_5190\|MSN_Messenger_File_Transfer\|MSN_Messenger_Voice\|MSNP\|MSSQL\|MS-SQL-Monitor\|MS-SQL-Server\|Multidropper\|Napster_Client_6600-6699\|Napster_directory_4444\|Napster_directory_5555\|Napster_directory_6666\|Napster_directory_7777\|Napster_directory_8888_primary\|Napster_redirector\|nbdatagram\|nbname\|nbsession\|NBT\|nfsd\|nfsprog\|nlockmgr\|NoBackO\|OAS-NameServer\|OAS-ORB\|Oracle-1524\|Orbix-1570\|Orbix-1571\|param-prblm\|pcANYWHERE\|pcANYWHERE-data\|pcANYWHERE-stat\|pcnfsd\|pcTELECOMMUTE-FileSync\|pop-3\|Port_6667_trojans\|RainWall_Command\|RainWall_Daemon\|RainWall_Status\|RAT\|RDP\|Real-Audio\|Remote_Storm\|RexxRave\|rpc-111\|rtsp\|securidprop\|sg-aol-messenger\|sg-citrix-metaframe\|sg-direct-connect\|sg-dns\|sg-edonkey\|sg-firewall1\|sg-fw1-client-auth\|sg-gnutella\|sg-hotline\|sg-icmp\|sg-ipsec\|sg-irc\|sg-msn-messenger\|sg-napster\|sg-nbt\|sg-netmeeting\|sg-pc-anywhere\|sg-pptp\|sg-time\|sg-wins-services\|sg-yahoo-messenger\|Shadyshell\|SKIP\|SkyDance-T\|smtp\|snmp\|snmp-read\|snmp-trap\|SNTP\|SocketsdesTroie\|sqlnet1\|sqlnet2-1521\|sqlnet2-1525\|sqlnet2-1526\|ssh\|StoneBeat-Control\|StoneBeat-Daemon\|SubSeven\|SubSeven-G\|syslog\|T.120\|TACACSplus\|telnet\|Terrortrojan\|tftp\|TheFlu\|time-exceeded\|timestamp\|timestamp-reply\|TransScout\|Trinoo\|UltorsTrojan\|userdef-SGS-SRL-423\|usserdef-SGS-mng-2456\|VPN1_IPSEC_encapsulation\|winframe\|WinHole\|Xanadu\|Yahoo_Messenger_messages\|Yahoo_Messenger_Webcams\|ypbind\|yppasswd\|ypserv\|ypupdated\|ypxfrd\|ZSP' >> $final
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
echo "Goodbye..."
echo " " 
