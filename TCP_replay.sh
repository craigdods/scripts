#!/bin/bash
# Add back in reads once complete

echo "Hello, welcome to the replay script"
echo "Please confirm which interface will be defined as the Client"
#read C_int
C_int=eth8
echo "Please confirm which interface will be defined as the Server"
#read S_int
S_int=eth9
echo "Thank you"
echo ""

############# NEEDS FIXING
echo "Please confirm the Destination MAC is for the Client Stream:"
#read CD_MAC
CD_MAC="00:23:e9:97:0e:06"
echo "Please confirm the Destination MAC is for the Server Stream:"
#read SD_MAC
SD_MAC="00:00:0c:07:ac:2c"

echo "PCAPs in the current directory:"
ls | grep pcap | grep -v 'final\|first'
echo ""
echo "Please specify which pcap file we will be replaying:"
pcap_file=$(ls | grep pcap | grep -v 'final\|first')
#read pcap_file
#Cache file
cache_file=$(echo $pcap_file"."cache | sed 's/.pcap//g')
#Output pcaps
first_run="first_run_$pcap_file"
final_run="final_$pcap_file"

#Determine local interface MACs
C_MAC=$(ifconfig $C_int| grep HWaddr | awk '{print $5}')
S_MAC=$(ifconfig $S_int| grep HWaddr | awk '{print $5}')

# Parse First SYN
echo "Parsing PCAP"
FIRST_SYN=`tcpdump -r $pcap_file -ne | grep "Flags \[S\]" | head -n 1`

#MAC Parsing pcap 
OS_MAC=$(echo "$FIRST_SYN" | awk '{print $2}')
OD_MAC=$(echo "$FIRST_SYN" | awk '{print $4}' | sed 's/,//g')
#IP Parsing from pcap
S_IP=$(echo "$FIRST_SYN" | awk '{print $10}'| awk -F[\.] '{print $1"."$2"."$3"."$4}')
D_IP=$(echo "$FIRST_SYN" | awk '{print $12}'| awk -F[\.] '{print $1"."$2"."$3"."$4}')

#Create Interfaces - Defaults to /24
#Client
ifconfig $C_int $S_IP netmask 255.255.255.0 up
#Server
ifconfig $S_int $D_IP netmask 255.255.255.0 up

#Rewrite IP section (skipping for now - not required)
#

#Prepare and create the cache
tcpprep --auto=client --cachefile=$cache_file --pcap=$pcap_file

# Rewrite MAC addresses
#SMAC
tcprewrite --enet-smac=$C_MAC,$S_MAC --cachefile=$cache_file --infile=$pcap_file --outfile=$first_run
#DMAC
tcprewrite --enet-dmac=$CD_MAC,$SD_MAC --cachefile=$cache_file --infile=$first_run --outfile=$final_run

#Cleanup
rm $first_run

echo ""
echo "To run, copy/paste this at your convenience:"
echo ""
echo "			tcpreplay --pps=1 --intf1=$C_int --intf2=$S_int --cachefile=$cache_file $final_run"
echo ""
