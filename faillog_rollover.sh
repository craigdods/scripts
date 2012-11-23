#!/bin/sh
# Faillog rollover script written by Craig Dods
# 23/11/2012
# This script is provided with no warranty. User assumes all risk
#
# Install into crontab to run every minute
# crontab -e
# * * * * * /bin/bash <path_to_script>/faillog_rollover.sh

rm /var/log/faillog
touch /var/log/faillog
chmod 644 /var/log/faillog
