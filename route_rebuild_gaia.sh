#!/bin/bash
# Written by Craig Dods

echo "Hello, please enter the correct log file to analyze"
ls | grep routes
read logfile

echo "Thank you - Rebuilding the routing table now"

#Multiple DB overrides since GAIA is a little buggy with this right now:
#[Expert@GAIA1]# clish -c "lock database override"
#CLINFR0771  Config lock is owned by admin. Use the command 'lock database override' to acquire the lock.
#[Expert@GAIA1]# clish -c "lock database override"
#CLICMD0201  Config lock is already turned on.

clish -c "lock database override" 
clish -c "lock database override"

# Route commands are split to avoid this (default has /0 which it doesn't like...):
# CLINFR0409  IPv4 unicast bitmask check fails: Invalid bitmask value in 0.0.0.0/0; valid range is 1-32
#set static-route 0.0.0.0/0
#----^^^^^^^^^^^^^^^^^^^^^^

# Add the default route:
cat $logfile | grep 0.0.0.0\/0 | awk '{print "clish -c \"set static-route default nexthop gateway address ",$2" on \""}' | sh

# Add all of the routes (excluding default route)
cat $logfile | sed '/0.0.0.0\/0/d' | awk '{print "clish -c \"set static-route ",$1" nexthop gateway address ",$2" on \""}' | sh
clish -c "save config"

echo "Finished rebuilding the routing table..."
echo " "
echo "Please remember to verify if the routes were rebuilt correctly!!"
echo "Goodbye "
clish -c "unlock database"