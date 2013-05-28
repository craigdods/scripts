#!/bin/bash
# CMA HA Sync state checker
# Written by Craig Dods

# Source environment
. /etc/profile.d/CP.sh

# Example for cma_ha_a - probably want some type of loop here...
################################################################################################################
echo "Results for cma_ha_a"
mdsenv cma_ha_a
cma_stat=`cpmistat -o schema -r mg cma_ha_b | grep mgStatusOK | sed 's/(//g;s/)//g;s/:mgStatusOK//g;s/^[ \t]*//'`

  if [ $cma_stat = 0 ]
	then
	#Fire Check and record the following in the ticket
	cpmistat -o schema -r mg cma_a_secondary | grep 'mgStatusOK\|mgSync'
	fi
	
################################################################################################################

# Output of the command looks like:
#Results for cma_ha_b
#	:mgStatusOK (0)
#	:mgSyncStatus (Lagging)

