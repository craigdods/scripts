#!/bin/bash
#Written by Craig Dods 25/11/2013
source /etc/profile.d/CP.sh

#Designed to be run from CRON
# */5 * * * * /bin/bash /home/admin/scripts/status_monitoring.sh >> /home/admin/ALERT_LOG.txt 2>&1

####### Connections table Monitoring
CONN_TABLE_THRESHOLD=50000
CONN_TABLE_SIZE=$(fw tab -t connections -s |grep connections |awk '{print $4}')
CONN_TABLE_LIMIT=75000
CONN_TABLE_LIMIT_ACTUAL=$(fw tab -t connections | head -n 3 | grep "limit" | awk -F, '{print $9}' | sed 's/\ limit //g')
####### 

###### CLEAR HUNG PDP SEARCH from other scripts
ps aux | grep "pdp i s 1" | grep -v grep | awk '{print $2}' | xargs kill -9 2>&1 &

####### Identity Awareness table sizes
PDP_THRESH=200
PEP_THRESH=200

PDP_SESS=$(fw tab -t pdp_sessions -s | grep pdp | awk '{print $4}')
PDP_IP=$(fw tab -t pdp_ip -s | grep pdp | awk '{print $4}')
PDP_TIMER=$(fw tab -t pdp_timers -s | grep pdp | awk '{print $4}')
PDP_NET_REG=$(fw tab -t pdp_net_reg -s | grep pdp | awk '{print $4}')
PDP_NET_DB=$(fw tab -t pdp_net_db -s | grep pdp | awk '{print $4}')

PEP_NET_REG=$(fw tab -t pep_net_reg -s | grep pep | awk '{print $4}')
PEP_CLIENT_DB=$(fw tab -t pep_client_db -s | grep pep | awk '{print $4}')
PEP_SRC_MAP=$(fw tab -t pep_src_mapping_db -s | grep pep | awk '{print $4}')

####### Cluster Monitoring
#Determine if Active/Standby
CPHA_ACTIVE=$(cphaprob stat | grep local | grep Active)
CPHA_STAT=$(cphaprob stat | grep -i "down\|attention")

####### IFMAP Monitoring (only on primary cluster member)
#Should equal Connected
IF_STAT=$(pdp i s | grep Connected | tail -n 1 | awk '{print $4}')
#Print IF-MAP Manager/Controller IP
IF_PEER=$(pdp i s | grep Connected | tail -n 1 | awk '{print $2}')
#GET Netstat output and verify 2 active connections
NETSTAT=$(netstat -na | grep $IF_PEER | grep "\:443" | wc -l)

####### 
LOGFILE='/home/admin/ALERT_LOG.txt'
DATE=$(/bin/date)
touch $LOGFILE

#ALERT FOR CONNECTION TABLE THRESHOLD
if [ "$CONN_TABLE_SIZE" -gt "$CONN_TABLE_THRESHOLD" ]
	then
		echo $DATE 
		echo "****CONNECTION Table Threshold of $CONN_TABLE_THRESHOLD Exceeded!*****" 
		echo "Current Connection Size:" 
		echo $CONN_TABLE_SIZE 
	fi

#ALERT FOR CONNECTION TABLE SIZE MODIFICATIONS
if [ "$CONN_TABLE_LIMIT_ACTUAL" -lt "$CONN_TABLE_LIMIT" ]
	then
		echo $DATE 
		echo "****CONNECTION Table Limit HAS DECREASED from $CONN_TABLE_LIMIT!*****" 
		echo "Current Connection Table Limit:" 
		echo $CONN_TABLE_LIMIT_ACTUAL 
	fi

#Monitoring Identity Awareness table sizes

#ALERT FOR PDP THRESHOLDS - LESS THAN OR EQUAL
if [ "$PDP_SESS" -le "$PDP_THRESH" ]
	then
		echo $DATE 
		echo "****PDP_SESSIONS TOO LOW*****" 
		echo "Current PDP Sessions:" 
		echo $PDP_SESS 
	fi

if [ "$PDP_IP" -le "$PDP_THRESH" ]
	then
		echo $DATE 
		echo "****PDP_IP TOO LOW*****" 
		echo "Current PDP IP value:" 
		echo $PDP_IP 
	fi

if [ "$PDP_TIMER" -le "$PDP_THRESH" ]
	then
		echo $DATE 
		echo "****PDP_TIMERS TOO LOW*****" 
		echo "Current PDP Timers:" 
		echo $PDP_TIMER 
	fi

if [ "$PDP_NET_REG" -le "$PDP_THRESH" ]
	then
		echo $DATE 
		echo "****PDP_NET_REG TOO LOW*****" 
		echo "Current PDP_NET_REG:" 
		echo $PDP_NET_REG 
	fi

#Custom value for PDP_NET_DB
if [ "$PDP_NET_DB" -le 5 ]
	then
		echo $DATE 
		echo "****PDP_NET_DB TOO LOW*****" 
		echo "Current PDP_NET_DB:" 
		echo $PDP_NET_DB 
	fi

if [ "$PEP_NET_REG" -le "$PEP_THRESH" ]
	then
		echo $DATE 
		echo "****PEP_NET_REG TOO LOW*****" 
		echo "Current PEP_NET_REG:" 
		echo $PEP_NET_REG 
	fi

if [ "$PEP_CLIENT_DB" -le "$PEP_THRESH" ]
	then
		echo $DATE 
		echo "****PEP_CLIENT_DB TOO LOW*****" 
		echo "Current PEP_CLIENT_DB:" 
		echo $PEP_CLIENT_DB 
	fi

if [ "$PEP_SRC_MAP" -le "$PEP_THRESH" ]
	then
		echo $DATE 
		echo "****PEP_SRC_MAPPING_DB TOO LOW*****" 
		echo "Current PEP_SRC_MAP:" 
		echo $PEP_SRC_MAP 
	fi

#### Monitor Cluster Activity
#REPORT DOWN STATE
if [ "$CPHA_STAT" != "" ]
	then
		echo $DATE 
		echo "****CLUSTER STATUS DOWN*****" 
		echo "Current CLUSTER STATUS:" 
		echo $CPHA_STAT 
	fi

# RUN CHECKS ONLY ON ACTIVE DEVICE
if [ "$CPHA_ACTIVE" != "" ]
	then
	#GET IF-MAP Connection Status
	if [ "$IF_STAT" != "Connected" ]
	then
		echo $DATE 
		echo "****IF-MAP CONNECTION DOWN*****" 
		echo "Current IF-MAP STATUS:" 
		echo $IF_STAT 
	fi
	#CHECK Netstat for 2 active SSL connections back to Controller/MGR
	if [ "$NETSTAT" -ne 2 ]
	then
		echo $DATE 
		echo "****IF-MAP CONNECTION ISSUE REPORTED VIA NETSTAT*****" 
		echo "Current connections over 443 to $IF_PEER:" 
		echo $NETSTAT 
	fi
	else
	#Do nothing
	:
	fi

# Cleanup log errors
sed -i '/ckpSSL/d;/kill/d' $LOGFILE

