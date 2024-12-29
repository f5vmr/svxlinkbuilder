#!/bin/bash
lang=$(echo $LANG | grep -o '^[a-zA-Z]*_[a-zA-Z]*')
#### Define Variables ####
CONF="/etc/svxlink/svxlink.conf"
MODULE="/etc/svxlink/svxlink.d"
OP="/etc/svxlink"

#### Welcome Message ####
#### GROUPS AND USERS ####
# clear
echo -e "$(date)" "${YELLOW} #### Creating Groups and Users #### ${NORMAL}" |  tee -a  /var/log/install.log
source "${BASH_SOURCE%/*}/functions/groups.sh"
make_groups


#### BACKUP CONFIGURATION ####
 # clear
	echo -e "$(date)" "${GREEN} #### Backing up configuration to : $CONF.bak #### ${NORMAL}"|  tee -a  /var/log/install.log

 	if [ -f "$CONF" ]; then
     cp -p "$CONF" "$CONF.bak"
else
    echo "File $CONF does not exist."
fi

##
 	cd /



# Ensure the ers file has the correct permissions


# Read the content from the source file into the ers file
	 mkdir scripts
	 	 cp -f svxlinkbuilder/configs/svxlink.conf /etc/svxlink/
	 cp -f svxlinkbuilder/addons/node_info.json /etc/svxlink/node_info.json
 	 cp -f svxlinkbuilder/resetlog.sh scripts/resetlog.sh
 	( crontab -l 2>/dev/null; echo "59 23 * * * scripts/resetlog.sh ") |  crontab -
     mkdir /usr/share/svxlink/events.d/local
	 cp /usr/share/svxlink/events.d/*.tcl /usr/share/svxlink/events.d/local/
	
 # clear
	echo -e "$(date)" "${YELLOW} #### Changing Log file suffix #### ${NORMAL}" |  tee -a  /var/log/install.log

 	 sed -i '/^LOGFILE=/ { /[^.log]$/ s/$/.log/ }' /etc/default/svxlink

	clear
	cd /
	echo -e "$(date)" "${YELLOW} #### Checking IP Addresses #### ${NORMAL}" |  tee -a  /var/log/install.log
	
	
	 # clear
	echo -e "$(date)" "${RED} #### Restarting svxlink.service #### ${NORMAL}" |  tee -a  /var/log/install.log
	
 	 systemctl restart svxlink.service

	##.service isn't necessary ##
echo -e "$(date)" "${GREEN} #### Installation complete #### ${NORMAL}" |  tee -a  /var/log/install.log
whiptail --title "Installation Complete" --msgbox "Installation complete. Go to the Dashboard" 8 78
echo -e "$(date)" "${RED} #### Complete #### ${NORMAL}" |  tee -a  /var/log/install.log

#exit

 


	
 
