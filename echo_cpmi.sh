#!/bin/bash
#Written by Craig Dods - 05/22/2013

echo ""
echo "Beginning to stop MDS/CMA's..."
echo " "

#Stopping CMA/MDS

echo "mdsstop -m" | sh > /dev/null 2>&1
find /opt/CPmds-R76/customers/ / -name fwopsec.conf | awk -F/ '{print $5}' | grep -v 'customers\|conf\|fw1\|opsec' | uniq | awk '{print "mdsstop_customer " $1}' | sh > /dev/null 2>&1

echo ""
echo "Waiting for CMA's to stop fully"
echo " "
sleep 15

#Making the required changes:

echo ""
echo "Making Changes..."
echo " "

echo "cpmi_server conn_buf_size 20000000" >> /opt/CPmds-R76/conf/mdsdb/fwopsec.conf

find /opt/CPmds-R76/customers/ / -name fwopsec.conf | grep -vi edge | awk '{print "echo \"cpmi_server conn_buf_size 20000000\" >> " $1}' | sh > /dev/null 2>&1

rm /opt/CPmds-R76/conf/mdsdb/CPMILinksMgr.db

find /opt/CPmds-R76/customers/*/conf/ / -name applications.C | grep -vi 'preupgrade\|defaultdatabase\|opt/Cpsuite' | awk '{print "rm " $1}' | sh > /dev/null 2>&1

find /opt/CPmds-R76/customers/*/conf/ / -name CPMILinksMgr.db | grep -vi 'preupgrade\|defaultdatabase\|opt/Cpsuite' | awk '{print "rm " $1}'| sh > /dev/null 2>&1

#Starting MDS/CMA:

echo ""
echo "Changes Complete - Starting CMA's back up (please be patient!)"
echo ""

echo "mdsstart -m" | sh > /dev/null 2>&1
find /opt/CPmds-R76/customers/ / -name fwopsec.conf | awk -F/ '{print $5}' | grep -v 'customers\|conf\|fw1\|opsec' | uniq | awk '{print "mdsstart_customer " $1}' | sh > /dev/null 2>&1

echo ""
echo "Finished!"
echo ""

