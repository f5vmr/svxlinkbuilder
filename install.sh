#### INSTALLATION SCRIPT ####
# Setting non-superuser elements #
#### INITIALISE ####
home="/home/pi"
cd $home
sudo -c 'echo "ls -l"' 
clear
source "${BASH_SOURCE%/*}/functions/initialise.sh"
initialise
#### CHECK OS ####
source "${BASH_SOURCE%/*}/functions/check_os.sh"
check_os
#### CHECK USER ####
source "${BASH_SOURCE%/*}/functions/check_user.sh"
###usercheck

#### SuperUser Install ####
#sudo ./install_main.sh
sudo -c 'echo "ls -l *.sh"'
