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
sudo ./svxlinkbuilder/install_main_fr.sh
elif  [[ "$LANG_OPTION" == "4" ]] 
then
sudo ./svxlinkbuilder/install_main_es.sh
else
sudo ./svxlinkbuilder/install_main.sh
fi
