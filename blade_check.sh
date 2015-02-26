#!/bin/bash
# Written by Michael Natkin
#############################################################################
# Output details
#############################################################################

# Define hostname of the installation and the date and time of execution
HNAME=`hostname`
NOW=$(date +"%F-%H%M")

# Simplify the output variable
# If you wish to change the output file name from the default, this is the place to change it:
OUTFILE=/var/log/checkup-$HNAME-$NOW.txt

#############################################################################
#  FFEATURE CHECKS                                                          #
#############################################################################

echo "   ### Basic installed feature check ### " >> $OUTFILE 2>&1
$CPDIR/bin/cpprod_util CPPROD_GetKeyValues Products 0 >> $OUTFILE 2>&1

      ##############################################################################
      #                                                                            #
      # Check what features (blades) are running (detailed check)                  #
      # This section was extracted and adapted from machine_info.sh (Eyal Sher, Raz Amir,      #
      # Eitan Lugassi)                                                             #
      #                                                                            #
      ##############################################################################

      # blades - format is: "short name for user" property-name [inner set-name]
      BLADECHECK=$TMP/blade_names
      BLADESTAT=$TMP/blade_disabled

      cat<<_ > $BLADECHECK
FW             firewall
MGMT           management
MNTR           monitor_blade
UDIR           user_dir_blade
VPN            VPN_1
QOS            floodgate
MAB            connectra
URLF           uf_integrated
A_URLF         advanced_uf_blade
AV             anti_virus_blade
ASPM           antispam_integrated
APP_CTL        application_firewall_blade
IPS            Name                      SD_profile
DLP            data_loss_prevention_blade
IA             identity_aware_blade_installed  identity_aware_blade
SSL_INSPECT    ssl_inspection_enabled
ANTB		        anti_malware_blade
MON		        real_time_monitor
EVNT           event_analyzer
RPTR           reporting_server
EVCOR          ips_event_correlator
EVNT           ips_event_manager
EVIN           smartevent_intro
MTA            mta_enabled
TED            threat_emulation_blade
_

      # property values that indicate a disabled blade:
       cat<<_ > $BLADESTAT
No_protection
not-installed
false
_

       # Run as function to support return codes

       activeblades() {
       # print a line, e.g. "Enabled Blades: FW MGMT VPN IPS":
       echo -n "* Active blades:" >> $OUTFILE 2>&1   # start a single line ...

       OBJ_FILE=$FWDIR/database/objects.C
       if ! [ -r $OBJ_FILE ] 2>/dev/null
          then
          		 echo " N/A - cannot read file: $OBJ_FILE"
           		 return 1
       fi

       REG_FILE=$CPDIR/registry/HKLM_registry.data
       if [ ! -r $REG_FILE ] 2>/dev/null
           then
           		 echo " N/A - cannot read file: $REG_FILE"
            		 return 1
       fi

       SIC_NAME=$(
       		 awk -F\" '
		 		 /^[[:blank:]]+:MySICname \("/ {
		 		 		 print toupper($2) # case-insensitive
		 		 		 exit              # one match only
		 		 }
		 ' $REG_FILE
        )

        if [ -z "$SIC_NAME" ]
             then
             		 echo ' N/A - failed to retrieve SIC name'
              		 return 1
        fi

        OBJ_NAME=$(
        		 awk -F\( "
		 		 /^\t\t: \(/ {
		 		 # save current set's name as object's context:
		 		 obj=\$2
		 		 }
		 		 /^\t\t\t:sic_name \(/ {
		 		 		 # match the saved SIC name with current set's:
		 		 		 if (toupper(\$2)~/^\"$SIC_NAME\"/) {
		 		 		 		 print obj
		 		 		 		 exit
		 		 		 }
		 		 }
		 " $OBJ_FILE
        )

        if [ -z "$OBJ_NAME" ]
             then
             		 echo ' N/A - failed to match an object to SIC name'
              		 return 1
        fi

        # dump the local object:
        cat $OBJ_FILE | tr '\t' ' ' | sed -n "/^  : ($OBJ_NAME$/,/^  )/p" > $TMP/local_obj

        # go over the blades file, skip empty lines:
        grep -v "^[[:blank:]]*$" $BLADECHECK | while read LINE
        do
        		 eval "set -- $LINE" # set positional parameters ("eval" preserves quotes)
		 		 # try to find a blade's value - if unavailable, skip to next blade:
        		 sed -n "/^   :${3-$2} (/,/^   )/p" $TMP/local_obj | \
		 		 grep "^   ${3+ }:$2 (" > $TMP/blade_val || continue
		 		 # match value for "disabled" - if unmatched, assume enabled:
        		 grep -wqf $BLADESTAT $TMP/blade_val || \
		 		 echo -n " $1"  # append the blade's name to line, e.g. " MGMT"
        done
        echo # end the blades line (carriage-return)
        }

        activeblades >> $OUTFILE 2>&1

        if [ -z "$SIC_NAME" ]
           then
                echo "Unable to determine SIC name of module" >> $OUTFILE 2>&1
           else
                echo "SIC Name of module: $SIC_NAME" >> $OUTFILE 2>&1
        fi

        if [ -z "$OBJ_NAME" ]
             then
                echo "Unable to determine object name of module" >> $OUTFILE 2>&1
             else
                echo "Object name: $OBJ_NAME" >> $OUTFILE 2>&1
        fi
        # Cleanup temporary files
        rm $TMP/local_obj
        rm $TMP/blade_val
        rm $BLADECHECK
        rm $BLADESTAT
