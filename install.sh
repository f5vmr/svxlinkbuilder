#### INSTALLATION SCRIPT ####
# Setting non-superuser elements #
#### INITIALISE ####
# clear
source "${BASH_SOURCE%/*}/functions/initialise.sh"
initialise
cd $home 
echo -e "${GREEN} #### OS = $operating_system and Current user = $logname #### ${NORMAL}" | sudo tee -a  /var/log/install.log
#### SuperUser Install ####
#### LANGUAGE ####
source "${BASH_SOURCE%/*}/functions/language.sh"
which_language

if  [[ "$LANG_OPTION" == "2" ]] 
then
##French
sudo ./svxlinkbuilder/install_main_fr.sh

elif  [[ "$LANG_OPTION" == "3" ]]
##US English
then
sudo ./svxlinkbuilder/install_main.sh

elif  [[ "$LANG_OPTION" == "4" ]] 
then
##Spanish
sudo ./svxlinkbuilder/install_main_es.sh
else
##UK English
sudo ./svxlinkbuilder/install_main.sh
fi
