#!/bin/sh
#
# Script written by Craig Dods
#
# This script is provided for debugging purposes only and comes with absolutely with NO 
# WARRANTY
# 
# User assumes all risk.
#
# Please direct any inquiries to the script's originator
#
# Interrupt this script with a Control-C to stop
# YOU MUST make sure any processes which may have been spawned are killed manually
# Using ps aux|grep kdebug etc to find processes is the easiest way of doing so.
#
#. /etc/profile.d/CP.sh
#Some versions of IPSO require this shell instead:
/opt/CPsuite-R71/svn/tmp/.CPprofile.sh

# Input the appropriate SR Number here
srnumber=0
# Input the correct customer/partner name here (make sure name is between ' ')	
custname='SunLife'
# This dictates the length of time the debugs are collected in seconds
sleeptime=60
# This defines whether SecureXL is disabled during debug captures or not.
# Unless your problem is SXL specific, it is usually suggested to disable this
# So that all information can be captured by the debugs
# 1 is enabled (IE SecureXL SHOULD be disabled - true) 0 is disabled (IE SecureXL Should be left ALONE - false)
sxloff=1


# Everything below this line will define exactly what debugs and captures this script will execute.
# Please use with care (enabling too many will freeze a device)

# Debug section
# The following variable will define if you wish to run 'any' type of debugs.
# This must be set to 'yes' even if you are simply collecting VPN debugs (it sets debug buffer & kdebug collection)
# 1 is enabled (true) 0 is disabled (false)
kdebug_req=1

# The following variable defines exactly what module you run kernel debugs on, and which flags are enabled.
# Please make sure you define the module first, and keep all entries within the ' '
# An example would be (kern_mod='fw conn drop vm')
kern_mod='fw packet conn vm drop route nat xlate xltrc'

# Is Cluster debugging required? 
# 1 is enabled (true) 0 is disabled (false)
cluster_debug=0
# Cluster debug flags
cluster_mod='all'

# Is VPN debugging required? (VPN Module/IKE/VPND.elg etc) 
# 1 is enabled (true) 0 is disabled (false)
vpn_debug=0

# If you have enabled VPN debugging, please specify the VPN Modules you wish to run a kernel debug on
# An example would be (vpn_mod='driver err packet mspi ike mspi multik')
vpn_mod='all'

# Is Policy Server debugging required (DO NOT ENABLE THIS WITHOUT 'vpn_debug=1'!!!!!!) 
# 1 is enabled (true) 0 is disabled (false)
polsrv_debug=0

# Do you wish to conduct debugging on the FWD Process?
# 1 is enabled (true) 0 is disabled (false)
fwd_debug=0

# Do you wish to conduct debugging on the CPD Process?
# 1 is enabled (true) 0 is disabled (false)
cpd_debug=0

# Do you wish to conduct debugging on the FWM Process?
# 1 is enabled (true) 0 is disabled (false)
# In the current state of this script, FWM Debugs ONLY work while running on standalone devices.
# This is due to the SecureXL check that occurs. There is no error checking to ensure SXL is on before this check occurs for 'sxlstatus'
# If you need to run this on an SCS, make sure you disable fw monitor & sxlstatus before proceeding.
fwm_debug=0

# Packet Capture Section
# Do you need to capture an FW Monitor during this session?
# 1 is enabled (true) 0 is disabled (false)
fwmon_req=1

# Please define the fw monitor syntax you wish to use
# The default of course being (fwmon_syn= 'fw monitor \-e "accept;"')
# Please ensure any '-' have a '\' before them to account for sh
fwmon_syn='fw monitor \-e "accept"'

# The following variable will enable TCPDUMP collection on an interface of your choosing
# 1 is enabled (true) 0 is disabled (false)
tcpdump_req=1

# Do you need TCPDUMP running on more than one interface?(Server->Client troubleshooting etc)
# Setting this to 'yes' will give you an additional prompt to collect for an 'internal' interface.
# 1 is enabled (true) 0 is disabled (false)
multi_int_tcp=1

# Collection variables 
# Is a CPINFO required to be generated?
# 1 is enabled (true) 0 is disabled (false)
cpinfo_req=0

# Do you want the script to collect the messages files?
# 1 is enabled (true) 0 is disabled (false)
msg_collect=1

#
# Use this section with care 
# Definining nice level can have an adverse affect on the quality of the debugs collected
# Only adjust when required (performance impact)
# Increasing the nice level will give the debugs a lower priority in the scheduling queue.
# This will save CPU cycles for more vital operation (such as passing traffic)
# However this will prevent servicing of the debug collection buffer, and thus may result in lost debug information.
#
# The options for nice_level are: 'max', 'moderate', or 'none'.
nice_level=none


host=`hostname`
time=`date +'%m%d%H%M%S'`
dbgdir=/var/tmp/$time\_$host\_debug
stats=$dbgdir\/statistics
msgs=$dbgdir\/message_files
cphadir=$dbgdir\/cpha_files
pktcap=$dbgdir\/packet_captures
vpndir=$dbgdir\/vpn_debugs
kerndir=$dbgdir\/kernel_debugs
procdir=$dbgdir\/process_debugs
sxlstatus=`fwaccel stat |grep "Accelerator Status" | awk '{print $4}'`
filename=/var/tmp/$time\_$host\_debugs.tgz
datestamp=`/bin/date -u`
auxwait0=4
auxwait1=1
auxwait2=2
auxwait3=2
n10='nice -n +10'
n20='nice -n +19'

	echo "This script has been created for SR $srnumber ($custname)"
	echo " "
	echo "Any questions regarding this scripts functionality should be directed to Craig Dods"
	echo " "
	
	if [ $tcpdump_req = 1 ]
	then
		echo "For the purposes of collecting debugs relevant to this issue,"
		echo "you will be required to define certain variables before the script begins collecting it's information"
		echo " "
		echo "Firstly, we will need to capture packets on the relevant interface(s)"
	
			if [ $multi_int_tcp = 1 ]
			then
			echo " "
			fw getifs
			echo " "
			echo "Please select the correct *internal* interface from the above list (IE server-facing)"
			echo "(type the full logical name *exactly* as it appears)"
			echo " "
			read internal_int
			echo " "
			fi

		echo "Please specify the *primary external* interface from the above list (IE client-facing)"
		echo " "
		fw getifs
		echo " "
		echo "Please select the correct *external* interface from the above list"
		echo "(type the full logical name *exactly* as it appears)"
		read external_int1
		echo " "
		echo " "
		echo "                             **********Thank you **********"
		echo " "
	fi
	
	echo " "
	echo "This script assumes that you are already prepared to recreate the issue"
	echo "Do not do so until prompted"
	echo " "
	echo "Please press ENTER when you are ready for the debugs to begin." 
	read wait_on_enter
	echo "Running...."
	echo " "
		# Create the directory in which to place the debugs
		mkdir $dbgdir
		mkdir $stats
			if [ $tcpdump_req -eq 1 -o $fwmon_req -eq 1 ]
			then	
			mkdir $pktcap	
			fi

			mkdir $cphadir
			if [ $kdebug_req = 1 ]
			then
			mkdir $kerndir
			fi	
			if [ $vpn_debug = 1 ]
			then
			mkdir $vpndir
			fi

			if [ $msg_collect = 1 ]
			then
			mkdir $msgs
			fi
			
				echo " "
				echo " "
				sleep $auxwait1
				echo "***********************************************************************"
				echo "***Control+C*** has been disabled while this script is running."
				echo "This is for your own safety."	
				echo "Please allow the script to clean up after itself. It will do a better, cleaner job than humans can."			
				echo "Please do not try to press 'Control+C', as it can cause issues with packet captures."
				echo "***********************************************************************"				
				echo " "
	
				# The following trap command disables ability to Control+C out of the script
				# This has been implemented because apparently some people still had the desire to do this
				# Even though this would leave the system with full debugs running and junk files everywhere.
				trap '' 2
				sleep $auxwait0

				# Disable SXL if required (AFTER checking if it is enabled in the first place)
				if [ $sxlstatus = on ]
				then
				if [ $sxloff = 1 ]
				then
				fwaccel off
				echo " "
				fi
				fi
				
				# Cleanup old elg's
				if [ $vpn_debug = 1 ]
				then
				mv $FWDIR/log/ike.elg $FWDIR/log/ike.elg.bak
				mv $FWDIR/log/vpnd.elg $FWDIR/log/vpnd.elg.bak
				fi
			
				# Policy Serv Backup
				if [ $polsrv_debug = 1 ]
				then			
				cp $FWDIR/log/dtps.elg $FWDIR/log/dtps.elg.bak
				fi
				
				# Process Debug Check
				if [ $fwd_debug -eq 1 -o $cpd_debug -eq 1 -o $fwm_debug -eq 1 ] 	
				then
				mkdir $procdir
				fi

				# Process Debug Backup FWD
				if [ $fwd_debug = 1 ]
				then
				cp $FWDIR/log/fwd.elg $FWDIR/log/fwd.elg.bak
				fi

				# Process Debug Backup FWM
				if [ $fwm_debug = 1 ]
				then
				cp $FWDIR/log/fwm.elg $FWDIR/log/fwm.elg.bak
				fi

				# CPD
				if [ $cpd_debug = 1 ]
				then
				cp $CPDIR/log/cpd.elg $CPDIR/log/cpd.elg.bak
				fi
		
				#Random information collection 'pre' issue:
				ps aux > $stats/psaux_before.txt &
				netstat -s > $stats/netstat_s_before.txt &
				fw tab -s > $stats/tables_before.txt &
				netstat -ni > $stats/netstat_ni_before.txt &
				#fw tab -t connections -f > $stats/connections_table_before.txt &
				fw tab -s > $stats/tables_before.txt &

				# FWD Debug
				if [ $fwd_debug = 1 ]
				then	
				echo "Debugs are beginning now" >> $FWDIR/log/fwd.elg
				fw debug fwd on TDERROR_DBG_OPT=time,host,prog,topic,pid,tid
				fw debug fwd on TDERROR_ALL_ALL=5
				fw debug fwd on OPSEC_DEBUG_LEVEL=9
				fi

				# FWM Debug
				if [ $fwm_debug = 1 ]
				then	
				echo "Debugs are beginning now" >> $FWDIR/log/fwm.elg
				fw debug fwm on TDERROR_DBG_OPT=time,host,prog,topic
				fw debug fwm on TDERROR_ALL_ALL=5
				fw debug fwm on OPSEC_DEBUG_LEVEL=9
				fi
				
				# CPD Debug
				if [ $cpd_debug = 1 ]
				then
				echo "Debugs are beginning now" >> $CPDIR/log/cpd.elg
				cpd_admin debug on TDERROR_DBG_OPT=time,host,prog,topic,pid,tid
				cpd_admin debug on TDERROR_ALL_ALL=5
				cpd_admin debug on OPSEC_DEBUG_LEVEL=9
				fi
				
				# VPN debug begins
				if [ $vpn_debug = 1 ]
				then
				vpn debug on TDERROR_DBG_OPT=time,host,prog,topic,pid,tid
				vpn debug on TDERROR_ALL_ALL=5
				vpn debug on OPSEC_DEBUG_LEVEL=9
				vpn debug trunc
				echo " "
				fi
				
				# Policy Server Debug
				if [ $polsrv_debug = 1 ]
				then
				echo "The Debug Script was executed on exactly $datestamp" >> $FWDIR/log/dtps.elg
				dtps debug on
				fi

				# Debug begins
				
				if [ $kdebug_req = 1 ]
				then
				fw ctl debug on
				echo " "
				fw ctl debug -buf 32768
				if [ $vpn_debug = 1 ]
				then
				echo " "
				fw ctl debug -m VPN $vpn_mod	
				fi
				echo " "
				fw ctl debug -m $kern_mod
				if [ $cluster_debug = 1 ]
				then
				fw ctl debug -m cluster $cluster_mod
				fi
				echo " "
				if [ $nice_level = max ]
				then
				echo " "
				$n20 fw ctl kdebug -T -f > $kerndir/kernel_debug.ctl &
				else
				if [ $nice_level = moderate ]
				then
				echo " "
				$n10 fw ctl kdebug -T -f > $kerndir/kernel_debug.ctl &
				else 
				if [ $nice_level = none ]
				then
				echo " "
				fw ctl kdebug -T -f > $kerndir/kernel_debug.ctl & 
				fi
				fi
				fi
				fi

				#TCPDUMP portion
				if [ $tcpdump_req = 1 ]
				then
				if [ $nice_level = max ]
				then
				$n20 tcpdump -nei $external_int1 -w $pktcap/ext_tcpdump1.cap &
				else
				if [ $nice_level = moderate ]
				then
				$n10 tcpdump -nei $external_int1 -w $pktcap/ext_tcpdump1.cap &
				else
				if [ $nice_level = none ]
				then
				tcpdump -nei $external_int1 -w $pktcap/ext_tcpdump1.cap &
				fi
				fi
				fi
				fi

				if [ $multi_int_tcp = 1 ]
				then
				if [ $nice_level = max ]
				then
				$n20 tcpdump -nei $internal_int -w $pktcap/int_tcpdump.cap &
				else
				if [ $nice_level = moderate ]
				then
				$n10 tcpdump -nei $internal_int -w $pktcap/int_tcpdump.cap &
				else
				if [ $nice_level = none ]
				then
				tcpdump -nei $internal_int -w $pktcap/int_tcpdump.cap &
				fi
				fi
				fi
				fi

				# FW Monitor portion
				if [ $fwmon_req = 1 ]
				then
				mkdir $dbgdir/junk
				if [ $nice_level = max ]
				then
				echo " "
				$n20 $fwmon_syn -o $pktcap/firewall_monitor.out > $dbgdir/junk/tmpfwmon.out 2>&1 &
				else	
				if [ $nice_level = moderate ]
				then
				echo " "
				$n10 $fwmon_syn -o $pktcap/firewall_monitor.out > $dbgdir/junk/tmpfwmon.out 2>&1 &
				else
				if [ $nice_level = none ]
				then
				echo " "
				$fwmon_syn -o $pktcap/firewall_monitor.out > $dbgdir/junk/tmpfwmon.out 2>&1 &
				fi
				fi
				fi
				fi
				sleep $auxwait1
				echo "-"
				echo "-"
				echo "******************************************************************"
				echo "		DEBUGS ARE RUNNING FOR $sleeptime SECONDS"
				echo " "
				echo "	PLEASE MAKE SURE TO REPLICATE THE ISSUE DURING THIS TIME"
				echo "******************************************************************"
				echo "-"
				echo "-"
				# Sleeps for preset sleeptime (60 seconds by default)
				sleep $sleeptime
				

		# CLEANUP
		if [ $kdebug_req = 1 ]
		then
		echo " "
		fw ctl debug 0
		fi
		if [ $vpn_debug = 1 ]
		then
		echo " "
		vpn debug ikeoff
		vpn debug off
		fi
		# Policy Server Debug
		if [ $polsrv_debug = 1 ]
		then
		dtps debug off
		fi
		
		sleep $auxwait2

				#The below section will find the PIDs of the debugs via awk, and use xargs to kill them gracefully.
				if [ $fwmon_req = 1 ]
				then
				echo " "
				ps aux | grep "fw monitor" | awk '{print $2}' | xargs kill -9 &
				echo " "
				fi
				if [ $tcpdump_req = 1 ]
				then
				echo " "
				ps aux | grep tcpdump | awk '{print $2}' | xargs kill -9 &
				fi
				if [ $kdebug_req = 1 ]
				then
				echo " "
				ps aux | grep kdebug | awk '{print $2}' | xargs kill -9 &	
				fi
				

				# FWD Debug Reset
				if [ $fwd_debug = 1 ]
				then	
				fw debug fwd off TDERROR_ALL_ALL=0
				fw debug fwd off OPSEC_DEBUG_LEVEL=0
				fi

				# FWM Debug Reset
				if [ $fwm_debug = 1 ]
				then	
				fw debug fwm off TDERROR_ALL_ALL=0
				fw debug fwm off OPSEC_DEBUG_LEVEL=0
				fi				
				
				# CPD Debug Reset
				if [ $cpd_debug = 1 ]
				then
				cpd_admin debug off TDERROR_ALL_ALL=0
				cpd_admin debug off OPSEC_DEBUG_LEVEL=0
				fi

				sleep $auxwait3
				
				#SecureXL 're-enabled' if required
				if [ $sxloff = 1 ]
				then
				if [ $sxlstatus = on ]
				then
				echo " "
				fwaccel on
				fi
				fi
				
				rm -rf $dbgdir/junk

				# Log collectiond
				if [ $vpn_debug = 1 ]
				then
				cp $FWDIR/log/ike* $vpndir/
				cp $FWDIR/log/vpnd* $vpndir/
				fi
			
				# Policy Server Debug
				if [ $polsrv_debug = 1 ]
				then
				cp $FWDIR/log/dtps.elg $vpndir/dtps.elg
				fi

				# Process Debug Collection for FWD
				if [ $fwd_debug = 1 ]
				then
				cp $FWDIR/log/fwd.elg* $procdir/
				fi

				# Process Debug Collection for FWM
				if [ $fwm_debug = 1 ]
				then
				cp $FWDIR/log/fwm.elg* $procdir/
				fi

				# CPD
				if [ $cpd_debug = 1 ]
				then
				cp $CPDIR/log/cpd.elg* $procdir/
				fi
		
				# Interface Selection records
				if [ $tcpdump_req = 1 ]
				then
				touch $pktcap/interface_selection.log

				echo "Primary External" >> $pktcap/interface_selection.log
				echo $external_int1 >> $pktcap/interface_selection.log
				
				if [ $multi_int_tcp = 1 ]
				then
				echo "Primary Internal" >> $pktcap/interface_selection.log
				echo $internal_int >> $pktcap/interface_selection.log
				fi
				fi

			
		# Information Collection 
 
		ps aux > $stats/psaux_after.txt &
		fw tab -s > $stats/tables_after.txt &
		netstat -s > $stats/netstat_s_after.txt &
		netstat -ni > $stats/netstat_ni_after.txt &
		#fw tab -t connections -f > $stats/connections_table_after.txt
		fw tab -s > $stats/tables_after.txt
		
		# Grab last set of messages from /var/log
		if [ $msg_collect = 1 ]
		then
		cp /var/log/messages* $msgs/
		fi
		
		# CPHA
		
		cphaprob stat > $cphadir/cphaprob_stat.txt &
		cphaprob -a if > $cphadir/cphaprob_aif.txt &
		cphaprob -i list > $cphadir/cphaprob_ilist.txt &
		
			# Finish up and compress
			echo " "
			sleep $auxwait1
			if [ $cpinfo_req = 1 ]
			then
			echo " "
			echo "This script will now trigger the collection of a CPINFO from this Firewall"
			echo "Please be patient while this runs - it can take several minutes"
			echo " "
			echo "Verifying that CPINFO is installed before proceeding:"
			fi

				# Check to see if CPINFO is installed
			if [ $cpinfo_req = 1 ]
			then
			if which cpinfo >/dev/null; then
			echo "Verified"
			echo "Collecting..."	
			if [ $nice_level = max ]
			then
			$n20 cpinfo -n -o $dbgdir/$host\_cpinfo.out
			else
			if [ $nice_level = moderate ]
			then
			$n10 cpinfo -n -o $dbgdir/$host\_cpinfo.out
			else
			if [ $nice_level = none ]
			then
			cpinfo -n -o $dbgdir/$host\_cpinfo.out
			fi
			fi
			fi
			
			echo " "
			echo "CPINFO has now completed..."
			echo " "
			else
			echo " "
			echo "CPINFO does not appear to be installed..."
			echo "Proceeding without CPINFO "
			echo " "
			fi
			fi
			# End

		echo "***********************************************************************"
		echo " "
		echo "Just a reminder; the files captured by the script will need to be transferred"
		echo "off of the firewall via Binary Mode"
		echo " "
		echo "***********************************************************************"
		echo " "
		echo "The script has now complete"
		echo "Your files are located in:"
		echo "***********************************************************************"
		echo " "
		echo $dbgdir
		echo " "
		echo "Would you like the script to compress the debugs for you and place them in /var/tmp?"
		echo "(yes or no - Must be typed exact)"
		echo " "
		read compressed

		if [ $compressed = yes ]
		then
		tar -zcf /var/tmp/$time\_$host\_debugs.tgz $dbgdir
		echo " "
		echo " "
		echo "The compressed files are found in"
		echo "$filename"
		echo " "
		fi
		
		# Allowing Control+C once again
		echo " "
		echo "You are now allowed to use Control+C again."
		echo " "
		trap 2

		echo " "
		echo "Have a nice day"
		echo "exiting..."

