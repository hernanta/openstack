#!/bin/sh

#################################################
# Bash script before installing rdo-openstack  #
# Written by @hernanta                        #
##############################################

#COLORS
# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan

#If you are using non-English locale make sure your /etc/environment is populated:
echo -e "$Cyan \n Setup locale..  $Color_Off"
sudo echo -e "LANG=en_US.utf-8 \nLC_ALL=en_US.utf-8" > /etc/environment
echo -e "$Green \n [DONE] $Color_Off"

#Edit selinux config from enforcing to permissive:
echo -e "$Cyan \n Edit selinux..  $Color_Off"
sudo sed -i -e 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config
echo -e "$Green \n [DONE] $Color_Off"

#If you plan on having external network access to the server and instances, this is a good moment to properly configure your network settings. A static IP address to your network card, and disabling NetworkManager are good ideas.
echo -e "$Cyan \n Prerequisites..  $Color_Off"
sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network
echo -e "$Green \n [DONE] $Color_Off"

#If your system meets all the prerequisites mentioned below, proceed with running the following commands:
echo -e "$Cyan \n Enables the openstack repository..  $Color_Off"
sudo yum -y install centos-release-openstack-ocata
echo -e "$Green \n [DONE] $Color_Off"

echo -e "$Cyan \n Updating system..  $Color_Off"
sudo yum -y update
echo -e "$Green \n [DONE] $Color_Off"

echo -e "$Cyan \n Install packstack installer..  $Color_Off"
sudo yum -y install openstack-packstack
echo -e "$Green \n [DONE] $Color_Off"

echo -e "$Cyan \n Generating a packstack answer file..  $Color_Off"
packstack --gen-answer-file=answers.txt
echo -e "$Green \n [DONE] $Color_Off"

echo -e "$Cyan \n Restart system..  $Color_Off"
sync; reboot
