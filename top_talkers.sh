#!/bin/bash
# Written by Craig Dods
# Last Edit on 05/03/2013
# Using SecureXL connection table vs general connections table to minimize impact on live devices. It is also significantly quicker to poll.

pause(){
  local m="$@"
	echo "$m"
	read -p "Press [Enter] key to continue..." key
}


clear
while :
do
clear
echo "Hello, Welcome to the Checkpoint Top Talkers display utility by Craig Dods"
echo "-----------------------------------------------"
echo "	     M A I N - M E N U"
echo "-----------------------------------------------"
echo "Please note that this is for use on devices with SecureXL enabled ONLY"
echo ""
echo "1.  Display the top 50 Source/Destination combos"
echo "2.  Display the top 50 Source/Destination combos with identical Destination Ports"
echo "3.  Display the top 50 Source/Destination combos with identical Source Ports"
echo "4.  Display the top 50 Sources"
echo "5.  Display the top 50 Destinations"
echo "6.  Display the top 50 Source/Destination combos on a Custom Destination Port"
echo "7.  Display the top 50 Source/Destination combos on a Custom Source Port"
echo "8.  Display the top 50 Sources on a Custom Destination Port"
echo "9.  Display the top 50 Destinations on a Custom Destination Port"
echo "10. Display the top 50 Sources on a Custom Source Port"
echo "11. Display the top 50 Destinations on a Custom Source Port"
echo "12. Display the top 50 Destination Ports"
echo "13. Display the top 50 Source Ports"
echo "14. Exit"

echo -n "Please Make A Selection:  "

read opt
 case $opt in
	1) 
	echo "     #      SRC IP          DST IP"
	fwaccel conns | awk '{printf "%-16s %-15s\n", $1,$3}' | sort | uniq -c | sort -n -r | head -n 50;
	pause;;
	2) 
	echo "     #      SRC IP          DST IP       DPort"
	fwaccel conns | awk '{printf "%-16s %-16s %-10s\n", $1,$3,$4}' | sort | uniq -c | sort -n -r | head -n 50
	pause;;
	3) 
	echo "     #      SRC IP          DST IP       SPort"
	fwaccel conns | awk '{printf "%-16s %-16s %10s\n", $1,$3,$2}' | sort | uniq -c | sort -n -r | head -n 50
	pause;;
	4) 
	echo "     #      SRC IP"
	fwaccel conns | awk '{print $1}' | sort | uniq -c | sort -n -r | head -n 50
	pause;;
	5) 
	echo "     #      DST IP"
	fwaccel conns | awk '{print $3}' | sort | uniq -c | sort -n -r | head -n 50
	pause;;
	6) 
	echo "Please enter the specific Destination Port you wish to filter for:  "
	read dport;
	echo ""
	echo "     #      SRC IP       DST IP on DPORT" $dport
	fwaccel conns | awk -v DPT=$dport '$4==DPT{print}' | awk '{printf "%-16s %-15s\n", $1,$3}' | sort | uniq -c | sort -n -r | head -n 50
	pause;;
	7) 
	echo "Please enter the specific Source Port you wish to filter for:  "
	read sport;
	echo ""
	echo "     #      SRC IP       DST IP on SPORT" $sport
	fwaccel conns | awk -v DPT=$sport '$2==DPT{print}' | awk '{printf "%-16s %-15s\n", $1,$3}' | sort | uniq -c | sort -n -r | head -n 50
	pause;;
	8) 
	echo "Please enter the specific Destination Port you wish to filter for:  "
	read dport;
	echo ""
	echo "     #  SRC IP on DPORT" $dport
	fwaccel conns | awk -v DPT=$dport '$4==DPT{print}' | awk '{printf "%-16s\n", $1}' | sort | uniq -c | sort -n -r | head -n 50
	pause;;
	9) 
	echo "Please enter the specific Destination Port you wish to filter for:  "
	read dport;
	echo ""
	echo "     #  DST IP on DPORT" $dport
	fwaccel conns | awk -v DPT=$dport '$4==DPT{print}' | awk '{printf "%-16s\n", $3}' | sort | uniq -c | sort -n -r | head -n 50
	pause;;
	10) 
	echo "Please enter the specific Source Port you wish to filter for:  "
	read sport;
	echo ""
	echo "     #  SRC IP on SPORT" $sport
	fwaccel conns | awk -v DPT=$sport '$2==DPT{print}' | awk '{printf "%-16s\n", $1}' | sort | uniq -c | sort -n -r | head -n 50
	pause;;
	11) 
	echo "Please enter the specific Source Port you wish to filter for:  "
	read sport;
	echo ""
	echo "     #  DST IP on SPORT" $sport
	fwaccel conns | awk -v DPT=$sport '$2==DPT{print}' | awk '{printf "%-16s\n", $3}' | sort | uniq -c | sort -n -r | head -n 50
	pause;;
	12) 
	echo "Please enter the specific Destination Port you wish to filter for:  "
	read sport;
	echo ""
	echo "     #  DST IP on SPORT" $dport
	fwaccel conns | awk -v DPT=$dport '$4==DPT{print}' | awk '{print $4}' | sort | uniq -c | sort -n -r | head -n 50
	pause;;
	13) 
	echo "Please enter the specific Source Port you wish to filter for:  "
	read sport;
	echo ""
	echo "     #  DST IP on SPORT" $sport
	fwaccel conns | awk -v DPT=$sport '$2==DPT{print}' | awk '{print $2}' | sort | uniq -c | sort -n -r | head -n 50
	pause;;

	14)
	exit 1;;

 esac
done
