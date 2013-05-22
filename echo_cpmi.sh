#!/bin/bash
#Written by Craig Dods - 05/22/2013

#Stopping CMA/MDS

echo "mdsstop -m" | sh
find /opt/CPmds-R76/customers/ / -name fwopsec.conf | awk -F/ '{print $5}' | grep -v 'customers\|conf\|fw1\|opsec' | uniq | awk '{print "mdsstop_customer " $1}' | sh

#Making the required changes:

echo "cpmi_server conn_buf_size 20000000" >> /opt/CPmds-R76/conf/mdsdb/fwopsec.conf

find /opt/CPmds-R76/customers/ / -name fwopsec.conf | grep -vi edge | awk '{print "echo \"cpmi_server conn_buf_size 20000000\" >> " $1}' | sh

find /opt/CPmds-R76/customers/*/conf/ / -name applications.C | grep -vi 'preupgrade\|defaultdatabase\|opt/Cpsuite' | awk '{print "rm " $1}' | sh 

find /opt/CPmds-R76/customers/*/conf/ / -name CPMILinksMgr.db | grep -vi 'preupgrade\|defaultdatabase\|opt/Cpsuite' | awk '{print "rm " $1}'| sh

#Starting MDS/CMA:
echo "mdsstart -m" | sh
find /opt/CPmds-R76/customers/ / -name fwopsec.conf | awk -F/ '{print $5}' | grep -v 'customers\|conf\|fw1\|opsec' | uniq | awk '{print "mdsstart_customer " $1}' | sh


