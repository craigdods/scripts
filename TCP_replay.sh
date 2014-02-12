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

echo "Please confirm what the Destination MAC is for the Client Stream:"
#read CD_MAC
CD_MAC="00:23:e9:97:0e:06"
echo $CD_MAC
echo "Please confirm what the Destination MAC is for the Server Stream:"
#read SD_MAC
SD_MAC="00:23:e9:97:0e:06"
echo "PCAPs in the current directory:"
ls | grep pcap | grep -v final
echo ""
echo "Please specify which pcap file we will be replaying:"
pcap_file=$(ls | grep pcap | grep -v final)
#read pcap_file
#Cache file
cache_file=$(echo $pcap_file"."cache | sed 's/.pcap//g')

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

#Rewrite IP section (skipping for now)
#

#Prepare and create the cache
tcpprep --port --cachefile=$cache_file --pcap=$pcap_file

# Rewrite MAC addresses
#SMAC
first_run="first_run_$pcap_file"
#echo "tcprewrite --enet-smac=$C_MAC,$S_MAC --cachefile=$cache_file --infile=$pcap_file --outfile=smac_$pcap_file"
tcprewrite --enet-smac=$C_MAC,$S_MAC --cachefile=$cache_file --infile=$pcap_file --outfile=$first_run
#DMAC
#echo "tcprewrite --enet-dmac=$CD_MAC,$SD_MAC --cachefile=$cache_file --infile=smac_$pcap_file --outfile=final_$pcap_file"
tcprewrite --enet-dmac=$CD_MAC,$SD_MAC --cachefile=$cache_file --infile=$first_run --outfile=final_$pcap_file

#Cleanup
rm $first_run
