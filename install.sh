#### INSTALLATION SCRIPT ####
# Setting non-superuser elements #
#### INITIALISE ####
home=/home/pi
cd $home
lang=$(echo $LANG | grep -o '^[a-zA-Z]*_[a-zA-Z]*')
 # clear
source "${BASH_SOURCE%/*}/functions/initialise.sh"
initialise
#### CHECK OS ####
source "${BASH_SOURCE%/*}/functions/check_os.sh"
check_os
#### CHECK USER ####
source "${BASH_SOURCE%/*}/functions/check_user.sh"
usercheck
echo -e "${GREEN} #### OS = $operating_system and Current user = $logname #### ${NORMAL}" | tee -a  /var/log/install.log
#### SuperUser Install ####
#### LANGUAGE ####
source "${BASH_SOURCE%/*}/functions/language.sh"
which_language


if [ "$LANG_OPTION" == "2" ] 
then 

sudo ./svxlinkbuilder/install_main_fr.sh
else

sudo ./svxlinkbuilder/install_main.sh
fi
