#!/bin/sh
# Manual configuration file required in /opt/devmgmt/etc/cp.cma.hapairs
# Configuration should be listed in two columns. Column A should be the primary CMA that resides on the current container. Column B should be the secondary CMA that resides elsewhere.

# Example:
# cat /opt/devmgmt/etc/cp.cma.hapairs 
#CMA_1		CMA_2
#CMA_3		CMA_4
#CMA_5		CMA_6
#CMA_7		CMA_8

. /etc/profile.d/CP.sh

if [ -f /opt/devmgmt/etc/cp.cma.hapairs ] ; then
	while read PRIMARY SECONDARY ; do

		mdsenv $PRIMARY
		cma_stat=`cpmistat -o schema -r mg $SECONDARY | grep mgStatusOK | sed 's/(//g;s/)//g;s/:mgStatusOK//g;s/^[ \t]*//'`

			if [ $cma_stat = 0 ]
			then
			#Fire Check and record the following in the ticket
			echo "Problematic CMA:" $SECONDARY
			cpmistat -o schema -r mg $SECONDARY | grep 'mgStatusOK\|mgSync'
			fi
			# Output of the command looks like:
			#Problematic CMA: CMA_Test
			#:mgStatusOK (0)
			#:mgSyncStatus (Lagging)



	done </opt/devmgmt/etc/cp.cma.hapairs

else
	echo "OK: No HA pairs defined in /opt/devmgmt/etc/cp.cma.hapairs"
	exit 0
fi
