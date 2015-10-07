#!/bin/bash

grep "Host Node" $INPUT_FILE -A 1 -B 1 | awk -F[\>] '{print $3}' | sed 's/\<br//g;s/<\/a//g;s/<//g;/^\s*$/d' | awk '{printf "%s"(NR%2?" ":RS),$0}' | awk '{print "set security address-book global address",$1,$2}'
