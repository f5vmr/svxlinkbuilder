#!/bin/bash
function initialise {
CONF_DIR=/etc/svxlink
LOG_DIR=/var/log/
PID_DIR=/var/run/
WWW_PATH=/var/www/
GUI_IDENTIFIER="SVXlink"
SVXLINK_VER="24.02"
SOUNDS_DIR=/usr/share/svxlink/sounds/
username=$USER
logname=$(whoami)
GREEN="\e[32m" 
NORMAL="\e[0m"
RED="\e[31m"
YELLOW="\e[33m"
home=/home/pi
echo -e "$(date)" "${GREEN} #### Commencing initialisation #### ${NORMAL}" | sudo tee -a /var/log/install.log
}