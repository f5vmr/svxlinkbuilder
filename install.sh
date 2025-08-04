#### INSTALLATION SCRIPT ####
# Setting non-superuser elements #
#### INITIALISE ####
# clear
source "${BASH_SOURCE%/*}/functions/initialise.sh"
initialise
cd $HOME
echo -e "${GREEN} #### OS = $operating_system and Current user = $logname #### ${NORMAL}" | sudo tee -a  /var/log/install.log
#### SuperUser Install ####
#### LANGUAGE ####
source "${BASH_SOURCE%/*}/functions/language.sh"
which_language

if  [[ "$LANG" == "fr_FR.UTF-8" ]] 
then
##French
sudo ./svxlinkbuilder/install_main_fr.sh

elif  [[ "$LANG" == "en_US.UTF-8" ]]
##US English
then
sudo ./svxlinkbuilder/install_main.sh

elif  [[ "$LANG" == "es_ES.UTF-8" ]] 
then
##Spanish
sudo ./svxlinkbuilder/install_main_es.sh
else
##UK English
sudo ./svxlinkbuilder/install_main.sh
fi
