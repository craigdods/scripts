#!/bin/bash
#Written by Craig Dods - October 28th, 2014

# 1 - Validate existence of Shared IDs
########################################################################################################################
echo

SHARED_ID_ADMIN=`grep admin /etc/passwd`
SHARED_ID_EXPERT=`grep "admin" /etc/passwd | grep "/bin/bash"`
SHARED_ID_NETRREX=`grep "netrrex" /etc/passwd`
SHARED_ID_NAGIOS=`grep "nagios" /etc/passwd`
SHARED_ID_MONITOR=`grep "monitor" /etc/passwd`

if [ -z "$SHARED_ID_ADMIN" ]
then 
	echo "admin user is not configured on this device"
else
	echo "admin user is configured on this device"
fi

if [ -z "$SHARED_ID_EXPERT" ]
then 
	echo "Expert is not configured on this device, or Admin may not be set up to drop in automatically"
else
	echo "admin user is configured to drop into Expert mode automatically (/bin/bash)"
fi	

if [ -z "$SHARED_ID_NETRREX" ]
then 
	echo "netrrex user is not configured on this device"
else
	echo "netrrex user is configured on this device"
fi	

if [ -z "$SHARED_ID_NAGIOS" ]
then 
	echo "nagios user is not configured on this device"
else
	echo "nagios user is configured on this device"
fi	

if [ -z "$SHARED_ID_MONITOR" ]
then 
	echo "The Monitor read-only user is not configured on this device"
else
	echo "The Monitor user is configured on this device"
fi	
########################################################################################################################

# 2.3 - Validation of Password Protection and encryption (HASH begins with $)
echo

ENCRYPTED_ADMIN=`grep "admin" /etc/shadow | awk -F[:] '{print $2}'`
ENCRYPTED_NETRREX=`grep "netrrex" /etc/shadow | awk -F[:] '{print $2}'`
ENCRYPTED_MONITOR=`grep "monitor" /etc/shadow | awk -F[:] '{print $2}'`

if [ ${ENCRYPTED_ADMIN:0:1} == "$" ]
	then
		echo "Admin user is ENCRYPTED"
	else	
		echo "Admin user is UNENCRYPTED"
fi

if [ ${ENCRYPTED_NETRREX:0:1} == "$" ]
	then
		echo "Netrrex user is ENCRYPTED"
	else	
		echo "Netrrex user is UNENCRYPTED"
fi

if [ -z "$SHARED_ID_MONITOR" ]
then 
	echo "Ignoring Monitor user for encryption check"
else
	if [ ${ENCRYPTED_MONITOR:0:1} == "$" ]
	then
		echo "Monitor user is ENCRYPTED"
	else	
		echo "Monitor user is UNENCRYPTED"
fi
fi	
########################################################################################################################

# 3 - Validation of MOTD/Restricted Access Notice - Search for common strings such as warning/unauthorized/restricted/prohibited
echo

MOTD=`grep -i "warning\|authorized\|restricted\|prohibited" /etc/motd`

if [ -z "$MOTD" ]
then 
	echo "The current /etc/motd is insufficient and should contain stronger language."
else
	echo "The current /etc/motd is acceptable."
fi	

########################################################################################################################

# 4 - Encryption of Stored passwords - Search /etc/pam.d for md5/sha512
echo

NONSYS_AUTH=`grep "password" /etc/pam.d/* | grep -v "deny\|system-auth"`
SYS_AUTH_MD5=`grep password /etc/pam.d/* | grep "\$ISA/pam_unix.so" | sed -n 's/.*\(md5\).*/\1/p'`
SYS_AUTH_SHA=`grep password /etc/pam.d/* | grep "\$ISA/pam_unix.so" | sed -n 's/.*\(sha512\).*/\1/p'`

if [ "$SYS_AUTH_MD5" == md5 ] || [ "$SYS_AUTH_SHA" == sha512 ]
then 
	echo "All references to /lib/security/$ISA)/pam_unix.so are using the required md5/sha512 hashing"
else
	echo "There is non-standard configuration that requires manual inspection as it does not meet the minimum requirements (MD5/SHA512)"
	echo $SYS_AUTH
fi	

echo

if [ -z "$NONSYS_AUTH" ]
then 
	echo "No extraneous configuration for stanzas not within system-auth."
else
	
	echo "There is non-standard configuration that requires manual inspection as it does not meet the minimum requirements (MD5/SHA512)"
	echo $NONSYS_AUTH
fi	
########################################################################################################################

# 5 - Operating system resources
echo
# 5.1 - OS system resources
# SCP
SCP_ADMIN=`grep admin /etc/scpusers`
SCP_EXPERT=`grep expert /etc/scpusers`
SCP_NETRREX=`grep admin /etc/scpusers`

if [ -z "$SCP_ADMIN" ]
then 
	echo "admin user is not defined within /etc/scpusers"
else
	echo "admin user is defined within /etc/scpusers"
fi

if [ -z "$SCP_EXPERT" ]
then 
	echo "expert user is not defined within /etc/scpusers"
else
	echo "expert user is defined within /etc/scpusers"
fi

if [ -z "$SCP_NETRREX" ]
then 
	echo "netrrex user is not defined within /etc/scpusers"
else
	echo "netrrex user is defined within /etc/scpusers"
fi

echo
# Expert Mode auto-login (use previous data):

if [ -z "$SHARED_ID_EXPERT" ]
then 
	echo "admin user not set up to drop in into expert mode automatically"
else
	echo "admin user is configured to drop into Expert mode automatically (/bin/bash)"
fi	

# Telnet listening on port 25
echo

TELNET_STATE=`netstat -na | awk -F[:] '{print $2}'| awk '{print $1}'| grep -Fx 25`
if [ -z "$TELNET_STATE" ]
then 
	echo "Telnet is not enabled on this device to listen on port 25"
else
	echo "Telnet is enabled on this device listening on port 25"
fi	

# Perl installed/enabled?
echo

if [ -x /usr/bin/perl ] 
	then	
		echo "Perl is installed"
	else
		echo "Perl is not installed"
fi

# Validate hardening and device management scripts have been run.

if [ -f /etc/scripts/versions/mss_modules ] 
	then	
		echo "Device has been hardened and device management scripts have been installed."
	else
		echo "Device was not hardened and device management scripts were not installed."
fi

########################################################################################################################

# 5.6 - Denial of Service - SNMP
echo

SNMP_STATE=`ps aux | grep snmp | grep -v grep`

if [ -z "$SNMP_STATE" ]
then 
	echo "SNMP daemon is not enabled on this device."
else
	echo "SNMP daemon is active"
fi	

########################################################################################################################

# 6 - Activity Auditing
echo

SYSLOG_LOCAL5=`grep "*.info;authpriv.none;cron.none;local5.none" /etc/syslog.conf | grep "/var/log/messages"`
SYSLOG_AUTH=`grep authpriv.* /etc/syslog.conf | grep "/var/log/secure"`
SYSLOG_EMERG=`grep "*.emerg;local5.none" /etc/syslog.conf | grep "*"`

if [ -z "$SYSLOG_LOCAL5" ]
then 
	echo "Auditing settings are incorrect for /var/log/messages."
else
	echo "Auditing correctly enabled for /var/log/messages at LOCAL5."
fi	

if [ -z "$SYSLOG_AUTH" ]
then 
	echo "Auditing settings are incorrect for /var/log/."
else
	echo "Auditing correctly enabled for /var/log/secure."
fi	

if [ -z "$SYSLOG_EMERG" ]
then 
	echo "Auditing settings are incorrect for emergency logging (everyone)."
else
	echo "Auditing correctly enabled for emergency messages (everyone receives)."
fi	

# Validate files exist
echo

if [ -f /var/log/messages ] 
	then	
		echo "/var/log/messages exists."
	else
		echo "/var/log/messages does not exist"
fi

if [ -f /var/log/wtmp ] 
	then	
		echo "/var/log/wtmp exists."
	else
		echo "/var/log/wtmp does not exist"
fi

if [ -f /var/log/secure ] 
	then	
		echo "/var/log/secure exists."
	else
		echo "/var/log/secure does not exist"
fi

# Validate NTP is sync'd to a secure source (209.134.18*)
echo

NTP_CHECK=`crontab -l | grep "ntpdate 209.134.18"`
if [ -z "$NTP_CHECK" ]
then 
	echo "ntpdate is not configured in crontab using a secure IBM MSS server"
else
	echo "ntpdate is configured in CRON leveraging a secure IBM MSS server"
fi	

echo
