#!/bin/sh
#
#  Script written by Craig Dods
#
#  Customer export/migration script
#
#  Collects required files for successful migration *away* from Provider-1

. /etc/profile.d/CP.sh
filename=$name\_migrate.tgz

echo "Please specify the name of the customer (no spaces)"
read name
filename=$name\_migrate.tgz
echo "Please enter the IP address of the CMA you wish to export" 

read customer

echo " "

echo "Thank you"

echo " "

echo "You have specified to use the following CMA:"

mdsstat |grep $customer |awk '{print $3}'

echo " "

echo "Is this correct (yes or no)"

read ans1

	if [ $ans1 = yes ] 

	then

	echo " "

	echo "Collecting the required files..."

	mdsenv $customer

	mkdir /var/tmp/$name\_migrate

	cd $FWDIR

	cp -pR conf /var/tmp/$name\_migrate/

	cp -pR database /var/tmp/$name\_migrate/

	cd $CPDIR

	cp -pR conf /var/tmp/$name\_migrate/conf.cpdir/

	cp -pR registry /var/tmp/$name\_migrate/

	cd /var/tmp/

	echo "Collection complete"

	echo " "

	echo "Compressing..."

	echo " "

	tar zcf $name\_migrate.tgz $name\_migrate

	echo "Compression complete"

	echo " "

	echo "Cleaning up"

	rm -rf /var/tmp/$name\_migrate/

	echo "Done"

	echo " "

	echo "Your files are located at /var/tmp/$filename"

	echo "Goodbye"

	

	else

	echo "exiting"

	fi
