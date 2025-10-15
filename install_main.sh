#!/bin/bash
lang=$(echo $LANG | grep -o '^[a-zA-Z]*_[a-zA-Z]*')
#### Define Variables ####
CONF="/etc/svxlink/svxlink.conf"
MODULE="/etc/svxlink/svxlink.d"
OP="/etc/svxlink"
export HOME
#### Welcome Message ####
source "${BASH_SOURCE%/*}/functions/welcome.sh"
welcome
source "${BASH_SOURCE%/*}/functions/configure.sh"
configure
#### TEST for SA818 ####
source "${BASH_SOURCE%/*}/functions/sa818_test.sh"
sa818_test
if [[ $sa818 == true ]]; then
source "${BASH_SOURCE%/*}/functions/sa818_menu.sh"
sa818_menu

else
echo "No SA818 device" |tee -a  /var/log/install.log
fi
#### USB SOUND CARD ####
source "${BASH_SOURCE%/*}/functions/sound_card.sh"
soundcard
#### NODE Selection ####
source "${BASH_SOURCE%/*}/functions/node_type.sh"
nodeoption
echo -e "$(date)" "${YELLOW} #### Node Type: $NODEOPTION #### ${NORMAL}" | sudo tee -a  /var/log/install.log

echo -e "$(date)" "${YELLOW} #### Sound Card: $HID $GPIOD $card #### ${NORMAL}" | sudo tee -a  /var/log/install.log	
echo -e "$(date)" "${YELLOW} #### Checking Alsa #### ${NORMAL}" | sudo tee -a  /var/log/install.log

#### REQUEST CALLSIGN ####
source "${BASH_SOURCE%/*}/functions/callsign.sh"
callsign
#### GROUPS AND USERS ####
# clear
echo -e "$(date)" "${YELLOW} #### Creating Groups and Users #### ${NORMAL}" | sudo tee -a  /var/log/install.log
source "${BASH_SOURCE%/*}/functions/groups.sh"
make_groups

#### CONFIGURATION VOICES ####
 # clear
	echo -e "$(date)" "${GREEN} #### Installing Voice Files #### ${NORMAL}" | sudo tee -a  /var/log/install.log

 	cd /usr/share/svxlink/sounds
	if [[ $lang == "en_US" ]]; then
	sudo git clone https://github.com/f5vmr/en_US.git

	else 
	sudo git clone https://github.com/f5vmr/en_GB.git
 
	fi
  	cd /etc/svxlink
   sudo chmod 775 -R *

#### BACKUP CONFIGURATION ####
 # clear
	echo -e "$(date)" "${GREEN} #### Backing up configuration to : $CONF.bak #### ${NORMAL}"| sudo tee -a  /var/log/install.log

 	if [ -f "$CONF" ]; then
    sudo cp -p "$CONF" "$CONF.bak"
else
    echo "File $CONF does not exist."
fi

##
 	cd /home/pi/
	SUDOERS_FILE="/etc/sudoers.d/svxlink"
	SOURCE_FILE="svxlinkbuilder/www-data.sudoers"
	if [ ! -f "$SOURCE_FILE" ]; then
  whiptail --title "Error" --msgbox "Source file $SOURCE_FILE does not exist. Exiting." 8 78
  exit 1
fi

# Check if the sudoers file exists
if [ -f "$SUDOERS_FILE" ]; then
  : > "$SUDOERS_FILE"
else
  touch "$SUDOERS_FILE"
fi

# Ensure the sudoers file has the correct permissions


# Read the content from the source file into the sudoers file
cat "$SOURCE_FILE" > "$SUDOERS_FILE"
chmod 0440 "$SUDOERS_FILE"
 	echo -e "$(date)" "${RED} #### Downloading prepared configuration files from the scripts #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	sudo mkdir /home/pi/scripts
	sudo cp -f /home/pi/svxlinkbuilder/addons/10-uname /etc/update-motd.d/
 	sudo cp -f /home/pi/svxlinkbuilder/configs/svxlink.conf /etc/svxlink/
	sudo cp -f /home/pi/svxlinkbuilder/addons/node_info.json /etc/svxlink/node_info.json
 	sudo cp -f /home/pi/svxlinkbuilder/resetlog.sh /home/pi/scripts/resetlog.sh
	sudo cp -f /home/pi/svxlinkbuilder/dtmf_setup.sh /home/pi/scripts/dtmf_setup.sh
 	(sudo crontab -l 2>/dev/null; echo "59 23 * * * /home/pi/scripts/resetlog.sh " ; echo "@reboot /home/pi/scripts/dtmf_setup.sh") | sudo crontab -
	sudo mkdir /usr/share/svxlink/events.d/local
	sudo cp /usr/share/svxlink/events.d/RepeaterLogicType.tcl /usr/share/svxlink/events.d/local/
    sudo cp /usr/share/svxlink/events.d/CW.tcl /usr/share/svxlink/events.d/local/
    sudo cp /usr/share/svxlink/events.d/Logic.tcl /usr/share/svxlink/events.d/local/
    #sudo cp -f /home/pi/svxlinkbuilder/configs/Logic.tcl /usr/share/svxlink/events.d/local/Logic.tcl
 	#sudo sed -i '/^LINK=\/adds\/dataserver_current\/httpparam/ c\LINK=/cgi-bin/data/dataserver.php?requestType=retrieve&dataSource=metars&hoursBeforeNow=3&stationString=' $MODULE/ModuleMetarInfo.conf
# clear
	echo -e "$(date)" "${GREEN} #### Setting Callsign to $CALL #### ${NORMAL}" | sudo tee -a  /var/log/install.log

 	sudo sed -i "s/MYCALL/$CALL/g" $CONF
 	sudo sed -i "s/MYCALL/$CALL/g" /etc/svxlink/node_info.json

	echo -e "$(date)" "${GREEN} #### Setting Squelch Hangtime to 10 mS #### ${NORMAL}" | sudo tee -a  /var/log/install.log
 	sudo sed -i s/SQL_HANGTIME=2000/SQL_HANGTIME=10/g $CONF
 
 # clear	
	echo -e "$(date)" "${YELLOW} #### Disabling audio distortion warning messages #### ${NORMAL}"| sudo tee -a  /var/log/install.log


 	sudo sed -i 's/PEAK_METER=1/PEAK_METER=0/g' $CONF

 # clear
	echo -e "$(date)" "${GREEN} #### Updating SplashScreen on startup #### ${NORMAL}" | sudo tee -a  /var/log/install.log

 	sudo sed -i "s/MYCALL/$CALL/g" /etc/update-motd.d/10-uname
 	sudo chmod 0775 /etc/update-motd.d/10-uname

 # clear
	echo -e "$(date)" "${YELLOW} #### Changing Log file suffix #### ${NORMAL}" | sudo tee -a  /var/log/install.log

 	sudo sed -i '/^LOGFILE=/ { /[^.log]$/ s/$/.log/ }' /etc/default/svxlink

	#### INSTALLING DASHBOARD ####
 # clear
	cd /home/pi
	echo -e "$(date)" "${YELLOW} #### Checking IP Addresses #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	
	source "${BASH_SOURCE%/*}/functions/get_ip.sh"
	ipaddress
 # clear
	cd /home/pi
	echo -e "$(date)" "${YELLOW} #### Installing Dashboard #### ${NORMAL}" | sudo tee -a  /var/log/install.log

	source "${BASH_SOURCE%/*}/functions/dash_install.sh"
	dash_install
 # clear
	echo -e "$(date)" "${GREEN} #### Dashboard installed #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	whiptail --title "IP Addresses" --msgbox "Dashboard installed. Please note your IP address is $ip_address on $device" 8 78
	cd /home/pi/

	 # clear
	echo -e "$(date)" "${GREEN} #### Setting up Node #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	source "${BASH_SOURCE%/*}/functions/node_setup.sh"
	nodeset
	#### Removal of unwanted files ####
	#echo -e "$(date)" "${YELLOW} #### Removing unwanted files #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	#source "${BASH_SOURCE%/*}/functions/deletion.sh"
	#delete
	#### TIME SELECTION ####
    source "${BASH_SOURCE%/*}/functions/time_selection.sh"
    timeselect
	#### Identification setup ####
	echo -e "$(date)" "${GREEN} #### Identification setup  #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	source "${BASH_SOURCE%/*}/functions/announce.sh"
	announce
	echo -e "$(date)" "${GREEN} #### Announcement setup complete  #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	source "${BASH_SOURCE%/*}/functions/tones.sh"
	tones
	echo -e "$(date)" "${GREEN} #### Tones setup complete  #### ${NORMAL}" | sudo tee -a  /var/log/install.log	
	cd /home/pi
	 # clear
 	echo -e "$(date)" "${RED} #### Changing ModuleMetar Link #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	
	if [[ $lang == "en_US" ]]; then
	## geting US Airports
	source "${BASH_SOURCE%/*}/functions/modulemetar_setup_us.sh"
	modulemetar
	else
	## getting UK Airports
	source "${BASH_SOURCE%/*}/functions/modulemetar_setup.sh"
	modulemetar
	fi	
	 # clear
	 cd /home/pi/
	echo -e "$(date)" "${RED} #### Changing ModuleEchoLink Link #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	source "${BASH_SOURCE%/*}/functions/echolink_setup.sh"
	echolinksetup
	
	 # clear
#	echo -e "$(date)" "${RED} #### Changing ModulePropagationMonitor #### ${NORMAL}" | sudo tee -a  /var/log/install.log
#	source "${BASH_SOURCE%/*}/functions/propagationmonitor_setup.sh"
#	propagationmonitor
	
	 # clear
	echo -e "$(date)" "${RED} #### Restarting svxlink.service #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	
 	sudo systemctl restart svxlink 

	##.service isn't necessary ##
echo -e "$(date)" "${GREEN} #### Installation complete #### ${NORMAL}" | sudo tee -a  /var/log/install.log
whiptail --title "Installation Complete" --msgbox "Installation complete. Go to the Dashboard" 8 78
echo -e "$(date)" "${RED} #### Complete #### ${NORMAL}" | sudo tee -a  /var/log/install.log

#exit

 


	
 
