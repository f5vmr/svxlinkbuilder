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
RED='\033[0;31m' # error
GREEN='\033[0;32m' # success
YELLOW='\033[0;33m' # warning
BLUE='\033[0;34m' # info
MAGENTA='\033[0;35m' # question
CYAN='\033[0;36m' # input
WHITE='\033[0;37m' # normal
NORMAL='\033[0m' # normal
locale=""
lang=""
echo -e "$(date)" "${BLUE} #### Commencing initialisation #### ${NORMAL}" |  tee -a /var/log/install.log
export HOME
}