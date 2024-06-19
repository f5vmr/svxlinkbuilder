#!/bin/bash
lang=$(echo $LANG | grep -o '^[a-zA-Z]*_[a-zA-Z]*')
#### Welcome Message ####
source "${BASH_SOURCE%/*}/functions/welcome.sh"
welcome
source "${BASH_SOURCE%/*}/functions/configure.sh"
configure
#### NODE Selection ####
source "${BASH_SOURCE%/*}/functions/node_type.sh"
nodeoption
echo -e "$(date)" "${YELLOW} #### Node Type: $NODEOPTION #### ${NORMAL}" | tee -a  /var/log/install.log
#### USB SOUND CARD ####
source "${BASH_SOURCE%/*}/functions/sound_card.sh"
soundcard
echo -e "$(date)" "${YELLOW} #### Sound Card: $HID $GPIOD $card #### ${NORMAL}" | tee -a  /var/log/install.log	
echo -e "$(date)" "${YELLOW} #### Checking Alsa #### ${NORMAL}" | tee -a  /var/log/install.log

#### REQUEST CALLSIGN ####
source "${BASH_SOURCE%/*}/functions/callsign.sh"
callsign
#### GROUPS AND USERS ####
clear
echo -e "$(date)" "${YELLOW} #### Creating Groups and Users #### ${NORMAL}" | tee -a  /var/log/install.log
source "${BASH_SOURCE%/*}/functions/groups.sh"
make_groups


#### CONFIGURATION VOICES ####
 # clear
	echo -e "$(date)" "${GREEN} #### Installing Voice Files #### ${NORMAL}" | tee -a  /var/log/install.log

 	cd /usr/share/svxlink/sounds
if [[ $LANG_OPTION == "3" ]]; then
	sudo wget https://github.com/sm0svx/svxlink-sounds-en_US-heather/archive/refs/tags/24.02.tar.gz
 	sudo tar -zxvf 24.02.tar.gz
	sudo rm 24.02.tar.gz

	else 
	sudo wget https://g4nab.co.uk/wp-content/uploads/2023/08/en_GB.tar_.gz
 	sudo tar -zxvf en_GB.tar_.gz
 	sudo rm en_GB.tar_.gz
	fi
  	cd /etc/svxlink
   sudo chmod 777 -R *

#### BACKUP CONFIGURATION ####
 # clear
	echo -e "$(date)" "${GREEN} #### Backing up configuration to : $CONF.bak #### ${NORMAL}"| tee -a  /var/log/install.log

 	sudo cp -p $CONF $CONF.bak
#
 	cd /home/pi/
 	echo -e "$(date)" "${RED} #### Downloading prepared configuration files from the scripts #### ${NORMAL}" | tee -a  /var/log/install.log
 	sudo mkdir /home/pi/scripts
	sudo cp -f /home/pi/svxlinkbuilder/addons/10-uname /etc/update-motd.d/
 	sudo cp -f /home/pi/svxlinkbuilder/configs/svxlink.conf /etc/svxlink/
 	sudo cp -f /home/pi/svxlinkbuilder/configs/gpio.conf /etc/svxlink/
 	sudo cp -f /home/pi/svxlinkbuilder/addons/node_info.json /etc/svxlink/node_info.json
 	sudo cp -f /home/pi/svxlinkbuilder/resetlog.sh /home/pi/scripts/resetlog.sh
 	(sudo crontab -l 2>/dev/null; echo "59 23 * * * /home/pi/scripts/resetlog.sh ") | sudo crontab -
    sudo mkdir /usr/share/svxlink/events.d/local
	sudo cp /usr/share/svxlink/events.d/*.tcl /usr/share/svxlink/events.d/local/
 # clear
	echo -e "$(date)" "${GREEN} #### Setting Callsign to $CALL #### ${NORMAL}" | tee -a  /var/log/install.log

 	sudo sed -i "s/MYCALL/$CALL/g" $CONF
 	sudo sed -i "s/MYCALL/$CALL/g" /etc/svxlink/node_info.json

	echo -e "$(date)" "${GREEN} #### Setting Squelch Hangtime to 10 mS ${NORMAL}" | tee -a  /var/log/install.log
 	sudo sed -i s/SQL_HANGTIME=2000/SQL_HANGTIME=10/g $CONF
 
 # clear	
	echo -e "$(date)" "${YELLOW} #### Disabling audio distortion warning messages #### ${NORMAL}"| tee -a  /var/log/install.log


 	sudo sed -i 's/PEAK_METER=1/PEAK_METER=0/g' $CONF

 # clear
	echo -e "$(date)" "${GREEN} #### Updating SplashScreen on startup #### ${NORMAL}" | tee -a  /var/log/install.log

 	sudo sed -i "s/MYCALL/$CALL/g" /etc/update-motd.d/10-uname
 	sudo chmod 0755 /etc/update-motd.d/10-uname

 # clear
	echo -e "$(date)" "${YELLOW} #### Changing Log file suffix ${NORMAL}" | tee -a  /var/log/install.log

 	sudo sed -i 's/log\/svxlink/log\/svxlink.log/g' /etc/default/svxlink
	
	#### INSTALLING DASHBOARD ####
 # clear
	cd /home/pi
	echo -e "$(date)" "${YELLOW} #### Checking IP Addresses #### ${NORMAL}" | tee -a  /var/log/install.log
	
	source "${BASH_SOURCE%/*}/functions/get_ip.sh"
	ipaddress
 # clear
	cd /home/pi
	echo -e "$(date)" "${YELLOW} #### Installing Dashboard #### ${NORMAL}" | tee -a  /var/log/install.log

	source "${BASH_SOURCE%/*}/functions/dash_install.sh"
	install_dash
 # clear
	echo -e "$(date)" "${GREEN} #### Dashboard installed #### ${NORMAL}" | tee -a  /var/log/install.log
	whiptail --title "IP Addresses" --msgbox "Dashboard installed. Please note your IP address is $ip_address on $device" 8 78
	cd /home/pi/

	 # clear
	echo -e "$(date)" "${GREEN} #### Setting up Node #### ${NORMAL}" | tee -a  /var/log/install.log
	source "${BASH_SOURCE%/*}/functions/node_setup.sh"
	nodeset
	#### Removal of unwanted files ####
	echo -e "$(date)" "${YELLOW} #### Removing unwanted files #### ${NORMAL}" | tee -a  /var/log/install.log
	source "${BASH_SOURCE%/*}/functions/deletion.sh"
	delete
	#### Identification setup ####
	echo -e "$(date)" "${GREEN} #### Identification setup  #### ${NORMAL}" | tee -a  /var/log/install.log
	source "${BASH_SOURCE%/*}/functions/announce.sh"
	announce
	echo -e "$(date)" "${GREEN} #### Announcement setup complete  #### ${NORMAL}" | tee -a  /var/log/install.log
	source "${BASH_SOURCE%/*}/functions/tones.sh"
	tones
	echo -e "$(date)" "${GREEN} #### Tones setup complete  #### ${NORMAL}" | tee -a  /var/log/install.log	
	cd /home/pi
	 # clear
 	echo -e "$(date)" "${RED} #### Changing ModuleMetar Link #### ${NORMAL}" | tee -a  /var/log/install.log
source "${BASH_SOURCE%/*}/functions/modulemetar_setup.sh"
modulemetar
	
	 # clear
	 cd /home/pi/
	echo -e "$(date)" "${RED} #### Changing ModuleEchoLink Link #### ${NORMAL}" | tee -a  /var/log/install.log
source "${BASH_SOURCE%/*}/functions/echolink_setup.sh"
echolinksetup
	
	 # clear
#	echo -e "$(date)" "${RED} #### Changing ModulePropagationMonitor #### ${NORMAL}" | tee -a  /var/log/install.log
#	source "${BASH_SOURCE%/*}/functions/propagationmonitor_setup.sh"
#	propagationmonitor
	
	 # clear
	echo -e "$(date)" "${RED} #### Setting up svxlink.service #### ${NORMAL}" | tee -a  /var/log/install.log

 	sudo systemctl enable svxlink_gpio_setup
	
 	sudo systemctl enable svxlink
	
 	sudo systemctl start svxlink_gpio_setup.service
	
 	sudo systemctl start svxlink.service


echo -e "$(date)" "${GREEN} #### Installation complete #### ${NORMAL}" | tee -a  /var/log/install.log
whiptail --title "Installation Complete" --msgbox "Installation complete. Reboot in progress" 8 78
echo -e "$(date)" "${RED} #### Rebooting SVXLink #### ${NORMAL}" | tee -a  /var/log/install.log

#exit


 sudo reboot


	
 
