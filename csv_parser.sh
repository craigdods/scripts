#!/bin/bash
# Written by Craig Dods
# Last Edit on 04/02/2013
# Service groups are currently non-functional due to the way CSV is created -> addelement requires separate types of objects (services vs network_objects), however it seems HP has added services into network groups (somehow...). For now -> They do not work. 

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
# If additional services get pulled in, just add it to the grep -v string at the end
# Only use if networks/objects don't use service names in them (like smtp-servers, ftp-servers, etc - HP does, have to manually edit...)
#grep -v $bad_grep $input_file | awk NF | awk -F, '$2=="Group"{ g=$1; print "create network_object_group",g } $7!="-" && $7!=""&& $7!="Log" && $7!="Any"{print "addelement network_objects " g " \x27\x27 network_objects:" $7}' | grep -v 'tcp\|udp\|telnet\|ftp\|http\|login\|ftp\|http\|icmp-proto\|telnet\|ftp\|http\|https\|NBT\|snmp\|ssh\|telnet\|ftp\|http\|MSSQL\|MS-SQL-Server\|sg-icmp\|telnet\|Entrust-Admin\|Entrust-KeyMgmt\|FW1_clntauth_telnet\|FW1_clntauth_http\|FreeTel-outgoing-server\|FreeTel-outgoing-client\|http\|https\|Napster_directory_8888_primary\|Oracle-1524\|smtp\|sqlnet1\|sqlnet2-1525\|ssh\|Citrix_ICA\|ftp-data\|gftp\|ghttp\|https\|imap\|ldap\|MSSQL\|nbname\|nbsession\|Oracle-1524\|pcANYWHERE-data\|pcANYWHERE-stat\|smtp\|sqlnet1\|sqlnet2-1526\|ssh\|telnet\|AH\|ESP\|SKIP\|IKE\|VPN1_IPSEC_encapsulation\|ZSP\|HTTP_wo_SCV\|ftp\|icmp-proto\|ldap\|ldap-ssl\|lpdw0rm\|telnet\|MSExchangeDSNSPI\|MSExchangeIS\|MSExchangeDirRef\|MSExchangeDSXDS\|MSExchangeSysAtt\|MSExchangeSysAttPriv\|MSExchangeStoreAdm\|MSExchangeDSNSPI\|MSExchangeDSRep\|MSExchangeMTA\|nbname\|nbdatagram\|nbsession\|mountd\|nfsd\|nfsprog\|nlockmgr\|pcnfsd\|ypbind\|yppasswd\|ypserv\|ypupdated\|ypxfrd\|H323\|ldap\|OAS-NameServer\|OAS-ORB\|Orbix-1570\|Orbix-1571\|gre\|Real-Audio\|rtsp\|http\|StoneBeat-Control\|StoneBeat-Daemon\|snmp\|echo-reply\|echo-request\|http\|https\|RDP\|snmp-read\|snmp-trap\|telnet\|http\|https\|echo-reply\|echo-request\|ftp\|echo-reply\|echo-request\|Freak2k\|nbsession\|ftp\|http\|echo-request\|info-req\|timestamp\|mask-request\|irc1\|irc2\|pcANYWHERE-data\|pcANYWHERE-stat\|pcANYWHERE\|pcTELECOMMUTE-FileSync\|securidprop\|ftp\|http\|https\|login\|telnet\|http\|https\|sg-icmp\|ftp\|http\|MS-SQL-Server\|nbsession\|Oracle-1524\|sg-dns\|sg-icmp\|sg-nbt\|sg-wins-services\|sqlnet2-1521\|telnet\|smtp\|ftp\|ftp-port\|http\|sg-icmp\|smtp\|snmp\|snmp-read\|snmp-trap\|syslog\|TACACSplus\|telnet\|tftp\|ftp\|ftp-port\|http\|sg-icmp\|telnet\|AOL\|ICQ_locator\|sg-irc\|sg-nbt\|ftp\|http\|login\|telnet\|Port_6667_trojans\|telnet\|sg-nbt\|FW1\|FW1_key\|sg-icmp\|sg-ipsec\|sg-pptp\|Citrix_ICA\|Citrix_ICA_Browsing\|ftp\|ftp-port\|sg-icmp\|telnet\|ftp\|ftp-port\|http\|Oracle-1524\|sg-icmp\|sqlnet1\|telnet\|ftp\|ftp-port\|sg-icmp\|telnet\|ftp\|ftp-port\|http\|https\|ldap\|nbsession\|Oracle-1524\|sqlnet1\|sqlnet2-1521\|sqlnet2-1525\|ssh\|telnet\|http\|sqlnet1\|ssh\|telnet\|CPD\|FW1\|FW1_ica_pull\|FW1_log\|http\|https\|http\|https\|sg-icmp\|ftp\|ftp-port\|telnet\|Entrust-Admin\|Entrust-KeyMgmt\|ftp\|ftp-port\|sg-icmp\|telnet\|https\|imap\|ldap\|sg-icmp\|smtp\|ftp\|ftp-port\|snmp\|telnet\|sg-icmp\|FW1\|FW1_log\|FW1_mgmt\|IKE\|ISAKMP\|RDP\|sg-fw1-client-auth\|FreeTel-outgoing-client\|FreeTel-outgoing-server\|ftp\|ftp-bidir\|ftp-pasv\|ftp-port\|sg-firewall1\|sg-fw1-client-auth\|FW1_clntauth_http\|FW1_clntauth_telnet\|Citrix_ICA\|http\|sg-icmp\|winframe\|Hotline_client\|Hotline_tracker\|dest-unreach\|echo-reply\|echo-request\|time-exceeded\|timestamp-reply\|echo-request\|info-req\|mask-request\|timestamp\|sg-icmp\|snmp\|snmp-read\|snmp-trap\|Citrix_ICA\|Citrix_ICA_Browsing\|sg-icmp\|sg-citrix-metaframe\|http\|https\|ftp\|ftp-port\|H323\|http\|https\|ldap\|MSSQL\|MS-SQL-Monitor\|MS-SQL-Server\|nbdatagram\|nbname\|nbsession\|Oracle-1524\|sg-icmp\|sg-nbt\|sg-netmeeting\|sg-pc-anywhere\|sqlnet1\|ssh\|T.120\|telnet\|ftp\|http\|https\|Oracle-1524\|sg-nbt\|sg-pc-anywhere\|sqlnet2-1521\|sqlnet2-1526\|ssh\|telnet\|AH\|ESP\|IKE\|ISAKMP\|SKIP\|irc1\|irc2\|ftp\|http\|https\|pop-3\|smtp\|telnet\|ftp\|sg-icmp\|ssh\|telnet\|ftp\|ftp-port\|sg-nbt\|sg-icmp\|sg-icmp\|sg-icmp\|sg-msn-messenger\|sg-yahoo-messenger\|sg-aol-messenger\|telnet\|sg-icmp\|archie\|ftp\|gopher\|http\|MSExchangeDirRef\|MSExchangeDS\|MSExchangeIS\|MSExchangeADL\|MSExchangeDirRef\|MSExchangeDirRep\|MSExchangeDS\|MSExchangeRA\|MSExchangeDirSync\|MSExchangeDS\|MS-SQL-Monitor\|MS-SQL-Server\|MSN_Messenger_5190\|MSN_Messenger_File_Transfer\|MSN_Messenger_Voice\|MSNP\|Napster_Client_6600-6699\|Napster_directory_4444\|Napster_directory_5555\|Napster_directory_6666\|Napster_directory_7777\|Napster_directory_8888_primary\|Napster_redirector\|nbdatagram\|nbname\|nbsession\|dest-unreach\|echo-reply\|echo-request\|icmp-proto\|info-reply\|info-req\|mask-reply\|mask-request\|param-prblm\|snmp\|time-exceeded\|timestamp\|timestamp-reply\|H323\|ldap\|mountd\|nfsd\|nfsprog\|nlockmgr\|pcnfsd\|ypbind\|yppasswd\|ypserv\|ypupdated\|ypxfrd\|OAS-NameServer\|OAS-ORB\|Orbix-1570\|Orbix-1571\|ftp\|ftp-port\|telnet\|sg-icmp\|Blubster\|GoToMyPC\|iMesh\|Madster\|sg-edonkey\|sg-gnutella\|sg-napster\|sg-hotline\|sg-direct-connect\|pcANYWHERE-data\|pcANYWHERE-stat\|pcTELECOMMUTE-FileSync\|sg-pc-anywhere\|http\|https\|gre\|sg-icmp\|RainWall_Command\|RainWall_Daemon\|RainWall_Status\|Real-Audio\|rtsp\|sg-icmp\|rpc-111\|securidprop\|AH\|ESP\|ftp\|http\|https\|IKE\|pop-3\|smtp\|telnet\|ftp\|http\|https\|Oracle-1524\|pop-3\|sg-dns\|sg-icmp\|sg-wins-services\|smtp\|snmp\|sqlnet2-1521\|sqlnet2-1526\|telnet\|sqlnet2-1521\|sqlnet2-1525\|sqlnet2-1526\|snmp\|StoneBeat-Control\|StoneBeat-Daemon\|https\|ssh\|tftp\|userdef-SGS-SRL-423\|usserdef-SGS-mng-2456\|https\|tftp\|echo-reply\|echo-request\|snmp-trap\|syslog\|http\|SNTP\|telnet\|sg-time\|sg-icmp\|Bionet-Setup\|Backage\|SubSeven-G\|SkyDance-T\|CrackDown\|DaCryptic\|DerSphere\|DerSphere_II\|Freak2k\|GateCrasher\|HackaTack_31785\|HackaTack_31787\|HackaTack_31788\|HackaTack_31789\|HackaTack_31790\|HackaTack_31791\|HackaTack_31792\|ICKiller\|InCommand\|Jade\|Kaos\|Kuang2\|lpdw0rm\|Mneah\|Multidropper\|NoBackO\|Port_6667_trojans\|RAT\|Remote_Storm\|RexxRave\|Shadyshell\|SocketsdesTroie\|SubSeven\|Terrortrojan\|TheFlu\|TransScout\|Trinoo\|UltorsTrojan\|WinHole\|Xanadu\|ftp\|ftp-port\|https\|sg-pc-anywhere\|telnet\|sg-icmp\|snmp\|snmp-trap\|telnet\|sg-icmp\|FW1\|FW1_key\|https\|sg-ipsec\|sg-pptp\|sg-icmp\|sg-icmp\|nbdatagram\|nbname\|nbsession\|Yahoo_Messenger_messages\|Yahoo_Messenger_Webcams\|sqlnet2-1521\|sqlnet2-1525\|sqlnet2-1526\|UDP_1200\|Allow To\|Members\|Direct_Connect_TCP\|Direct_Connect_UDP\|GNUtella\|MSN_Messenger_1863\|Yahoo_Messenger' >> $final
grep -v $bad_grep $input_file | awk NF | awk -F, '$2=="Group"{ g=$1; print "create network_object_group",g } $7!="-" && $7!=""&& $7!="Log" && $7!="Any"{print "addelement network_objects " g " \x27\x27 network_objects:" $7}'
grep -v $bad_grep $input_file | awk NF | awk -F, '$2=="Group"{ g=$1; print "update network_objects",g }' >> $final


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
