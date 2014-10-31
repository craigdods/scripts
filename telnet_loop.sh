#!/bin/sh

i=0

while [ $i -ne 1000 ]

   do

     telnet ocsp.verisign.com 80 <<EOF

EOF

   sleep 10

   i=`expr $i + 1`

   done

exit
