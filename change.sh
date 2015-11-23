#!/bin/bash
# Changeip.com Script for Linux base systems using bash
# Created to suite local need in specific case. Well tested with CENTOS 6.x n UBUNTU 12.x n Debian 7.x 8.x
# Powered by Ivan Bachvarov a.k.a SlaSerX
# http://linuxhelps.net
# October , 2015
# Uncomment below to view debug log
# set -x
 
# Various variables, make sure to change the changeip.com credentials and hostname as required.
CIPUSER=yourchangeip_account@xxx.xxx
CIPPASS=PASSWORD
CIPHOST=changeip_password
URL="https://nic.changeip.com/nic/update?ip"
# Temp files and log file to record updates if required
EXTIP="/tmp/externalip.txt"
NEWIP="/tmp/newip.txt"
LOG="/var/log/changeip.log"
DATE=`date`
 
# If external ip text file not found, then create one
if [ ! -e "$EXTIP" ] ; then
touch "$EXTIP"
fi
 
# Download current LIVE ip from intenret to match with old ip
wget -q -O /tmp/newip.txt http://ip.changeip.com:8245
a=`cat $EXTIP`
b=`cat $NEWIP  | cut -f 2 -d "=" | cut -f 1 -d "-" -s | grep -m 1 ^`
if [[ $a != "$b" ]]
then
 
# changeip update now
curl "$URL=$b&u=$CIPUSER&p=$CIPPASS&hostname=$CIPHOST"
 
# Update New WAN IP in OLD File
echo $b > $EXTIP
echo
 
# Print OLD vs New Comparision for REVIEW
echo Old IP = $a
echo New IP = $b
echo Update Time = $DATE
echo Update Done.
 
# Print OLD vs New Comparision for REVIEW in LOG FILE for later review
echo "*********************************************"  >> $LOG
echo New IP FOUND > $LOG
echo Old IP = $a >> $LOG
echo New IP found at $DATE and IP is = $b >> $LOG
 
# IF OLD and NEW ip are same, then no need to update, just EXIT
else
echo $DATE / No need to change IP. DDNS BASH Script / Powered by Ivan Bachvarov a.k.a SlaSerX
fi
 
# END
