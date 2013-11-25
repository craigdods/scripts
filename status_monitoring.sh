#!/bin/bash
#Written by Craig Dods 25/11/2013

####### Connections table Monitoring
CONN_TABLE_THRESHOLD=50000
CONN_TABLE_SIZE=$(fw tab -t connections -s |grep connections |awk '{print $4}')
CONN_TABLE_LIMIT=75000
CONN_TABLE_LIMIT_ACTUAL=$(fw tab -t connections | head -n 3 | grep "limit" | awk -F, '{print $9}' | sed 's/\ limit //g')
####### 

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
####### 

LOGFILE=/home/admin/ALERT_LOG.txt
DATE=$(/bin/date)
#REMOVE AFTER TESTING#######################################
rm $LOGFILE
############################################################
touch $LOGFILE

#ALERT FOR CONNECTION TABLE THRESHOLD
if [ "$CONN_TABLE_SIZE" -gt "$CONN_TABLE_THRESHOLD" ]
	then
		echo $DATE >> $LOGFILE
		echo "****CONNECTION Table Threshold of $CONN_TABLE_THRESHOLD Exceeded!*****" >> $LOGFILE
		echo "Current Connection Size:" >> $LOGFILE
		echo $CONN_TABLE_SIZE >> $LOGFILE
	fi

#ALERT FOR CONNECTION TABLE SIZE MODIFICATIONS
if [ "$CONN_TABLE_LIMIT_ACTUAL" -lt "$CONN_TABLE_LIMIT" ]
	then
		echo $DATE >> $LOGFILE
		echo "****CONNECTION Table Limit HAS DECREASED from $CONN_TABLE_LIMIT!*****" >> $LOGFILE
		echo "Current Connection Table Limit:" >> $LOGFILE
		echo $CONN_TABLE_LIMIT_ACTUAL >> $LOGFILE
	fi

#Monitoring Identity Awareness table sizes

#ALERT FOR PDP THRESHOLDS - LESS THAN OR EQUAL
if [ "$PDP_SESS" -le "$PDP_THRESH" ]
	then
		echo $DATE >> $LOGFILE
		echo "****PDP_SESSIONS TOO LOW*****" >> $LOGFILE
		echo "Current PDP Sessions:" >> $LOGFILE
		echo $PDP_SESS >> $LOGFILE
	fi

if [ "$PDP_IP" -le "$PDP_THRESH" ]
	then
		echo $DATE >> $LOGFILE
		echo "****PDP_IP TOO LOW*****" >> $LOGFILE
		echo "Current PDP IP value:" >> $LOGFILE
		echo $PDP_IP >> $LOGFILE
	fi

if [ "$PDP_TIMER" -le "$PDP_THRESH" ]
	then
		echo $DATE >> $LOGFILE
		echo "****PDP_TIMERS TOO LOW*****" >> $LOGFILE
		echo "Current PDP Timers:" >> $LOGFILE
		echo $PDP_TIMER >> $LOGFILE
	fi

if [ "$PDP_NET_REG" -le "$PDP_THRESH" ]
	then
		echo $DATE >> $LOGFILE
		echo "****PDP_NET_REG TOO LOW*****" >> $LOGFILE
		echo "Current PDP_NET_REG:" >> $LOGFILE
		echo $PDP_NET_REG >> $LOGFILE
	fi

#Custom value for PDP_NET_DB
if [ "$PDP_NET_DB" -le 5 ]
	then
		echo $DATE >> $LOGFILE
		echo "****PDP_NET_DB TOO LOW*****" >> $LOGFILE
		echo "Current PDP_NET_DB:" >> $LOGFILE
		echo $PDP_NET_DB >> $LOGFILE
	fi

if [ "$PEP_NET_REG" -le "$PEP_THRESH" ]
	then
		echo $DATE >> $LOGFILE
		echo "****PEP_NET_REG TOO LOW*****" >> $LOGFILE
		echo "Current PEP_NET_REG:" >> $LOGFILE
		echo $PEP_NET_REG >> $LOGFILE
	fi

if [ "$PEP_CLIENT_DB" -le "$PEP_THRESH" ]
	then
		echo $DATE >> $LOGFILE
		echo "****PEP_CLIENT_DB TOO LOW*****" >> $LOGFILE
		echo "Current PEP_CLIENT_DB:" >> $LOGFILE
		echo $PEP_CLIENT_DB >> $LOGFILE
	fi

if [ "$PEP_SRC_MAP" -le "$PEP_THRESH" ]
	then
		echo $DATE >> $LOGFILE
		echo "****PEP_SRC_MAPPING_DB TOO LOW*****" >> $LOGFILE
		echo "Current PEP_SRC_MAP:" >> $LOGFILE
		echo $PEP_SRC_MAP >> $LOGFILE
	fi



