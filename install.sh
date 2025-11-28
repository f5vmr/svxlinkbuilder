#!/bin/bash
#### INSTALLATION SCRIPT ####
# Setting non-superuser elements #
#### INITIALISE ####

source "${BASH_SOURCE%/*}/functions/initialise.sh"
initialise

cd /home/pi

# Log OS and user (screen + log)
echo -e "${GREEN} #### OS = $operating_system and Current user = $logname #### ${NORMAL}" | sudo tee -a /var/log/install.log > /dev/null

#### SuperUser Install ####
#### LANGUAGE ####
source "${BASH_SOURCE%/*}/functions/language.sh"
which_language

# Run language-specific installer
case "$LANG" in
    fr_FR.UTF-8)
        sudo ./svxlinkbuilder/install_main_fr.sh
        ;;
    en_US.UTF-8)
        sudo ./svxlinkbuilder/install_main.sh
        ;;
    es_ES.UTF-8)
        sudo ./svxlinkbuilder/install_main_es.sh
        ;;
    pt_PT.UTF-8)
        sudo ./svxlinkbuilder/install_main_pt.sh
        ;;
    it_IT.UTF-8)
        sudo ./svxlinkbuilder/install_main_it.sh
        ;;
    *)
        sudo ./svxlinkbuilder/install_main.sh  # Default UK English
        ;;
esac
