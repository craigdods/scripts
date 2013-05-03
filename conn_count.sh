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
echo "Hello, Welcome to the Checkpoint Top Talkers display utility"
echo "-----------------------------------------------"
echo "	     M A I N - M E N U"
echo "-----------------------------------------------"
echo "Please note that this is for use on devices with SecureXL enabled ONLY"
echo ""
echo "1. Display the top 50 Source/Destination combos"
echo "2. Display the top 50 Source/Destination combos with identical Destination Ports"
echo "3. Display the top 50 Source/Destination combos with identical Source Ports"
echo "4. Display the top 50 Sources"
echo "5. Display the top 50 Destinations"
echo "6. Exit"

echo -n "Please Make A Selection:  "

read opt
 case $opt in
	1) 
	echo "     #      SRC IP          DST IP"
	fwaccel conns | awk '{print $1,$3}' | sort | uniq -c | sort -n -r | head -n 50;
	pause;;
	2) 
	echo "     #      SRC IP          DST IP    DPort"
	fwaccel conns | awk '{print $1,$3,$4}' | sort | uniq -c | sort -n -r | head -n 50
	pause;;
	3) 
	echo "     #      SRC IP          DST IP    SPort"
	fwaccel conns | awk '{print $1,$3,$2}' | sort | uniq -c | sort -n -r | head -n 50
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
	exit 1;;

 esac
done

