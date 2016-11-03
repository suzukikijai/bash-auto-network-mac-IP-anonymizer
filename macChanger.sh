#!/bin/bash

#ethSlot Identifier log
ethV=$(ifconfig | grep -Eo '^eth[^ ]+')

#MAC Log
oldMacID=$(ifconfig eth0 | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}')

#IP Log
oldIPValue=$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
sleep 1
#Network Disrupt
echo umn1234 | sudo -S ifconfig eth0 down 
sleep 3
#MAC Spoof
echo umn1234 | sudo -S macchanger -A eth0 
sleep 3
#IP spoof
ipscrambler=$(echo $RANDOM % 150 + 100 | bc)
newipgenerated=192.168.0.$ipscrambler
echo umn1234 | sudo -S ifconfig eth0 $newipgenerated netmask 255.255.255.0
sleep 3
echo umn1234 | sudo -S ifconfig eth0 up

#ethSlot Identifier log
ethV=$(ifconfig | grep -Eo '^eth[^ ]+')

#MAC Log
newMacID=$(ifconfig eth0 | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}')

#IP Log
newIPValue=$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
rotateLog=$(echo Modified MAC:$newMacID and IP:$newIPValue)
echo `date +%d-%m-%Y::%H:%M`: $rotateLog | cat - spoof.log > temp && mv temp spoof.log
