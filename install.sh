#!/bin/bash
#### INSTALLATION SCRIPT ####
#### INITIALISE ####
# clear
source "${BASH_SOURCE%/*}/functions/initialise.sh"
initialise
cd /home/pi
echo -e  "${GREEN} #### OS = $operating_system and Current user = $logname #### ${NORMAL}" | tee -a  /var/log/install.log
#### SuperUser Install ####
#### LANGUAGE ####
source "${BASH_SOURCE%/*}/functions/language.sh"
which_language
echo -e "${GREEN} #### Language selected is $lang #### ${NORMAL}" | tee -a  /var/log/install.log

if  [[ "$LANG" == "fr_FR.UTF-8" ]] 
then
##French
lang=$(echo $LANG | grep -o '^[a-zA-Z]*_[a-zA-Z]*')
export lang
sudo ./svxlinkbuilder/install_main_fr.sh

elif  [[ "$LANG" == "en_US.UTF-8" ]]
##US English
then
lang=$(echo $LANG | grep -o '^[a-zA-Z]*_[a-zA-Z]*')
export lang
sudo ./svxlinkbuilder/install_main.sh

elif  [[ "$LANG" == "es_ES.UTF-8" ]] 
then
##Spanish
lang=$(echo $LANG | grep -o '^[a-zA-Z]*_[a-zA-Z]*')
export lang
sudo ./svxlinkbuilder/install_main_es.sh

elif  [[ "$LANG" == "pt_PT.UTF-8" ]] 
then
##Portuguese
lang=$(echo $LANG | grep -o '^[a-zA-Z]*_[a-zA-Z]*')
export lang
sudo ./svxlinkbuilder/install_main_pt.sh

elif  [[ "$LANG" == "it_IT.UTF-8" ]] 
then
##Italian
lang=$(echo $LANG | grep -o '^[a-zA-Z]*_[a-zA-Z]*')
export lang
sudo ./svxlinkbuilder/install_main_it.sh

else
##UK English
lang=$(echo $LANG | grep -o '^[a-zA-Z]*_[a-zA-Z]*')
export lang
sudo ./svxlinkbuilder/install_main.sh
fi
