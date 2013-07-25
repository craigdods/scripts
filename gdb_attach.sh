 #!/bin/bash

#test, and make sure the next line really outputs the CPU level (replace 5240 with pdpd pid):

# top -n 1 -p `pgrep pdpd`| grep pdpd | gawk ' { print $9, " all: ", $0 } '

 

 

file_pid=`pgrep pdpd`

 

COUNT=1;

 

#save max of 10 core files

while [ $COUNT -lt 10 ]; do

 if [ "$file_pid" -ge 1 ]; then

   echo "pid is $file_pid"

   

   pdpd_load=`top -n 1 |grep pdpd | gawk ' {print $9 } '`

   echo "pdpd_load is $pdpd_load"

   

 

   #http://www.linuxquestions.org/questions/programming-9/how-can-i-compare-floating-number-in-a-shell-script-336772/#post1712743

   #NOTE: do "if $1<$2" and not "$1>$2" (and give pdpd_load, 80 as arguements) because sometimes pdpd_load is 0, and then $1 will be 80 and not pdpd load!

   if [ "$(echo 80 $pdpd_load | awk '{if ($1 < $2) print "1"; else print "0"}')" -eq 1 ]; then

     echo "execute"

     

     let COUNT=COUNT+1

     echo "new count: $COUNT"

     file_loc=`which pdpd`

     #file_pid=`pgrep pdpd`

     echo "running gdb"

     echo `./gdb $file_loc $file_pid --batch -x cmds.txt`

 

     mv core.${file_pid} core.${file_pid}.${COUNT}

     echo "created new file: core.${file_pid}.${COUNT}"

 

     echo "sleeping for 30 seconds"

     sleep 30

   fi

 fi

 

 sleep 0

done

 

 

echo "finished. created $COUNT files."
