#!/bin/bash
# Written by Craig Dods
# Last Edit on 07/03/2013
# Debug script for Dupont ifmap/pdp/pep issues

. /etc/profile.d/CP.sh

pause(){
  local m="$@"
  echo "$m"
	read -p "Press [Enter] key to continue..." key
}

host=`hostname`
time=`date +'%m%d%H%M%S'`
dbgdir=/var/tmp/$time\_$host\_debug
msgs=$dbgdir\/message_files
elgs=$dbgdir\/elgs

mkdir $dbgdir
mkdir $msgs
mkdir $elgs

clear
while :
do
clear
echo "Hello, Welcome to the Dupont IFMAP Debug Script"
echo "Please allow the debugs to run for at least 60 seconds before terminating with option 2"
echo "-----------------------------------------------"
echo "	     M A I N - M E N U"
echo "-----------------------------------------------"
echo ""
echo "1.  Gather Debugs"
echo "2.  *****Disable all debugs and collect the *.elg's - DON'T FORGET!*****"
echo "3.  Print original instructions from Whatcha"
echo "4.  Exit"

echo -n "Please Make A Selection:  "

read opt
 case $opt in
	1) 
	echo "Gathering Debugs"
	ps auxx > $dbgdir/psauxx.txt &
	netstat -na | grep ESTABLI | grep 52.100.254. > $dbgdir/netstat_na.txt &
	$FWDIR/log/tabstat > $dbgdir/tabstat_output.txt &
	pdp ifmap connect all
	pdp if st > $dbgdir/pdp_if_stat.txt &
	pdp m a > $dbgdir/pdp_m_a.txt &
	pep sh u a > $dbgdir/pep_show_u_a.txt &
	pdp network reg > $dbgdir/pdp_net_reg.txt &
	pep show net reg > $dbgdir/pep_net_reg.txt &
	cpvinfo $FWDIR/lib/libpdplib.so > $dbgdir/libpdp_cpvinfo.txt
	cpvinfo $FWDIR/bin/pdpd > $dbgdir/pdpd_cpvinfo.txt
	cpvinfo $FWDIR/bin/pep > $dbgdir/pep_cpvinfo.txt
	cpvinfo $FWDIR/boot/modules/fwmod* > $dbgdir/fwmod_cpvinfo.txt
	pdp d set all all
	pdp debug rotate
	echo "Logs are collected and debugs are enabled - please remember to turn them off before you leave!"
	pause;;
	2) 
	echo "Disabling all debugs and collecting ELGs"
	pdp d of
	cp /var/log/messages* $msgs/
	cp $FWDIR/log/pdpd.elg* $elgs/
	cp $FWDIR/log/pepd.elg* $elgs/
	pause;;

	3) 
	echo "Debug instructions in the event IFMAP authentiation stops working
 
ps auxx
netstat -na | grep ESTABLI | grep 52.100.254.
$FWDIR/log/tabstat
pdp ifmap connect all
pdp if st
pdp m a
pep sh u a
pdp network reg
pep show net reg
pdp d set all all
pdp debug rotate
Install Policy - If netstat shows Established connections to Federation Server
pdp d of
Provide output of 
cpvinfo $FWDIR/lib/libpdplib.so
cpvinfo $FWDIR/bin/pdpd
cpvinfo $FWDIR/bin/pep
cpvinfo $FWDIR/boot/modules/fwmod*
gather the following files
/var/log/messages
$FWDIR/log/pdpd.elg*
$FWDIR/log/pepd.elg*
along with the output from the commands above.
As always please call me if you have any questions.

You may reply to this email or if you have difficulty responding via e-mail, you may login to the User Center:
https://usercenter.checkpoint.com/usercenter/index.jsp

Click on the Services & Downloads, SecureTrak, 28-687840931

You may also go to www.checkpoint.com/sr to access SecureTrak directly.  Please use your User Center login credentials.

Go to the Updates section at the bottom and press the Add

Thank you,
Whatcha McCallum
Group Escalations Manager
Check Point Software Technologies LTD.
O: 972.444.6533 C: 682.233.4335
E: wmccallum@checkpoint.com
for escalation path information go to http://www.checkpoint.com/services/contact/escalation.html
"
	pause;;
	4)
	exit 1;;

 esac
done
