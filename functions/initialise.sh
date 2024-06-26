#!/bin/bash
function initialise {
CONF_DIR=/etc/svxlink/
LOG_DIR=/var/log/
PID_DIR=/var/run/
WWW_PATH=/var/www/
GUI_IDENTIFIER="SVXlink"
SVXLINK_VER="24.02"
SOUNDS_DIR=/usr/share/svxlink/sounds/
username=$USER
logname=$(whoami)
GREEN="\033[1;32m" 
NORMAL="\033[0;39m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
home=/home/pi
echo -e "$(date)" "${GREEN} #### Commencing initialisation #### ${NORMAL}" | sudo tee -a /var/log/install.log
}