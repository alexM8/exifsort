#!/bin/bash

if [ -f .flashdrives ]
then
while true
	do
	df -h | sed -n '6,20p' | awk '{print $9}' | while read drive
		do
		cat .flashdrives | while read flash_uuid_name
			do
			if [ -f $drive/identity ]
			then
			echo $flash_uuid_name | grep `cat "$drive/identity"` > /dev/null
				if [ $? -eq 0 ]
					then
						echo "Identity found $flash_uuid_name. Begin the import? [y/n]";
						read answer < /dev/tty;
						if [[ $answer =~ ^[Yy]$ ]]
						then	cp -vR $drive/DCIM/ tmp/
							if [ $? -eq 0 ]
							then	echo "Import finished";
								tmp_photos=`find tmp/ -type f | wc -l`;
								dcim_photos=`find $drive/DCIM -type f | wc -l`;
								echo "Files in tmp is $tmp_photos";
								echo "Files on the flash drive is $dcim_photos";
								echo "Shall I remove photos photos from the $drive? [y/n]"
								read answerthis < /dev/tty;
									if [[ $answerthis =~ ^[Yy]$ ]]
									then rm -rfv $drive/DCIM/*;
									echo "Shall I eject the drive? [y/n]"
									read ejecting < /dev/tty;
										if [[ $ejecting =~ ^[Yy]$ ]]
										then diskutil unmount $drive;
										else echo "You canceled the eject operation. The script will continue to work in background"
										fi
									else echo "Files left on the flash drive. The script will continue to work in background"
									echo "Shall I eject the drive? [y/n]"
									read ejecting < /dev/tty;
										if [[ $ejecting =~ ^[Yy]$ ]]
										then diskutil unmount $drive;
										else echo "You canceled the eject operation. The script will continue to work in background"
										fi
									fi
							else echo "Some troubles with the import. The script will continue to work in background"
							fi
						else echo "You canceled the operation. The script will continue to work in background"
						fi	
				else :
				fi	
			fi
			done
		done
	sleep 1
	echo "Awaiting for the flash drive..."
	done
else echo "No records in the bootstrap drives database. First, execute bootstrap.sh"
exit 1
fi
