#!/bin/bash
#This script will add master-X to the HOSTS file - that is reqirened for KUDU Masters to start up.
#Oracle sometimes modify HOSTS file automatically
#Check if master-X is already in the HOSTS file.
if ! grep -q  "master-3" /etc/hosts > /dev/null
then
#If not in the HOSTS file add it to the end of line
   sudo sed  -i '/oracle-dev3/s/$/ master-3/' /etc/hosts
else
   echo "master-3 is in HOSTS file"
fi
##### Check that chonyd service is running
if ! ps cax | grep chronyd > /dev/null
then
#If the chronyd service is not running - start it
   sudo systemctl start chronyd
else
   echo "chronyd service is running"
fi
#Check that the hostname is a disred hostname.If not - set the hostname to the disred
echo "Current hostname: $HOSTNAME"
server_hostname=$HOSTNAME
desired_hostname="oracle-dev3"
echo "Desired hostanme: $desired_hostname"
if [ "$server_hostname" == "$desired_hostname" ]; then
    echo "hostname is good"
else
    echo "incorrect hostname"
    sudo hostnamectl set-hostname $desired_hostname
fi
