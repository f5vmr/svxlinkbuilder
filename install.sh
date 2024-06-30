#### INSTALLATION SCRIPT ####
# Setting non-superuser elements #
#### INITIALISE ####

lang=$(echo $LANG | grep -o '^[a-zA-Z]*_[a-zA-Z]*')
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
sudo localectl set-locale LANG=fr_FR.UTF-8
sudo ./svxlinkbuilder/install_main_fr.sh
elif  [[ "$LANG_OPTION" == "3" ]]
then
sudo localectl set-locale LANG=en_US.UTF-8
sudo ./svxlinkbuilder/install_main.sh
elif  [[ "$LANG_OPTION" == "4" ]] 
then
sudo localectl set-locale LANG=es_ES.UTF-8
sudo ./svxlinkbuilder/install_main_es.sh
else
sudo localectl set-locale LANG=en_GB.UTF-8
sudo ./svxlinkbuilder/install_main.sh
fi
