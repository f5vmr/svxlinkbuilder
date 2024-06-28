#!/bin/bash
lang=$(echo $LANG | grep -o '^[a-zA-Z]*_[a-zA-Z]*')
#### Welcome Message ####
source "${BASH_SOURCE%/*}/functions/welcome_fr.sh"
welcome
source "${BASH_SOURCE%/*}/functions/configure_fr.sh"
configure_fr
#### NODE Selection ####
source "${BASH_SOURCE%/*}/functions/node_type_fr.sh"
nodeoption
echo -e "$(date)" "${YELLOW} #### Type du Noed: $NODEOPTION #### ${NORMAL}" | sudo tee -a  /var/log/install.log
#### USB SOUND CARD ####
source "${BASH_SOURCE%/*}/functions/sound_card_fr.sh"
soundcard
echo -e "$(date)" "${YELLOW} #### Carte de son : $HID $GPIOD $card #### ${NORMAL}" | sudo tee -a  /var/log/install.log	
echo -e "$(date)" "${YELLOW} #### Verification d'Alsa #### ${NORMAL}" | sudo tee -a  /var/log/install.log

#### REQUEST CALLSIGN ####
source "${BASH_SOURCE%/*}/functions/callsign_fr.sh"
callsign
#### GROUPS AND USERS ####
clear
echo -e "$(date)" "${YELLOW} #### Creation des Groupes and Users #### ${NORMAL}" | sudo tee -a  /var/log/install.log
source "${BASH_SOURCE%/*}/functions/groups.sh"
 make_groups

#### CONFIGURATION VOICES ####
 # clear
	echo -e "$(date)" "${GREEN} #### Installation des dossiers de Voix  #### ${NORMAL}" | sudo tee -a  /var/log/install.log

 	cd /usr/share/svxlink/sounds
 	sudo wget https://g4nab.co.uk/wp-content/uploads/2023/08/fr_FR.tar_.gz

 	sudo tar -zxvf fr_FR.tar_.gz
 	sudo rm fr_FR.tar_.gz
  	cd /etc/svxlink
   sudo chmod 775 -R *

#### BACKUP CONFIGURATION ####
 # clear
	echo -e "$(date)" "${GREEN} #### Sauvegarder la configuration à : $CONF.bak #### ${NORMAL}"| sudo tee -a  /var/log/install.log

 	sudo cp -p $CONF $CONF.bak
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
 	echo -e "$(date)" "${RED} #### Téléchargement du dossier de configuration #### ${NORMAL}" | sudo tee -a  /var/log/install.log
 	sudo touch /etc/sudoers.d/svxlink
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
	echo -e "$(date)" "${GREEN} #### Indicatif à $CALL #### ${NORMAL}" | sudo tee -a  /var/log/install.log

 	sudo sed -i "s/MYCALL/$CALL/g" $CONF
 	sudo sed -i "s/MYCALL/$CALL/g" /etc/svxlink/node_info.json

	echo -e "$(date)" "${GREEN} ####  Squelch Hangtime à 10 mS ${NORMAL}" | sudo tee -a  /var/log/install.log
 	sudo sed -i s/SQL_HANGTIME=2000/SQL_HANGTIME=10/g $CONF
 
 # clear	
	echo -e "$(date)" "${YELLOW} #### Disabling audio distortion warning messages #### ${NORMAL}"| sudo tee -a  /var/log/install.log


 	sudo sed -i 's/PEAK_METER=1/PEAK_METER=0/g' $CONF

 # clear
	echo -e "$(date)" "${GREEN} #### Updating SplashScreen on startup #### ${NORMAL}" | sudo tee -a  /var/log/install.log

 	sudo sed -i "s/MYCALL/$CALL/g" /etc/update-motd.d/10-uname
 	sudo chmod 0775 /etc/update-motd.d/10-uname

 # clear
	echo -e "$(date)" "${YELLOW} #### Changing Log file suffix ${NORMAL}" | sudo tee -a  /var/log/install.log

 	sudo sed -i '/^LOGFILE=/ s/\(LOGFILE=.*\)\.log\>/\1.log/' /etc/default/svxlink
	#### INSTALLING DASHBOARD ####
 # clear
	cd /home/pi
	echo -e "$(date)" "${YELLOW} #### Vérification des adresses IP #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	
	source "${BASH_SOURCE%/*}/functions/get_ip.sh"
	ipaddress
 # clear
	cd /home/pi
	echo -e "$(date)" "${YELLOW} #### Installation du Tableau de Bord #### ${NORMAL}" | sudo tee -a  /var/log/install.log

	source "${BASH_SOURCE%/*}/functions/dash_install_fr.sh"
install_dash
 # clear
	echo -e "$(date)" "${GREEN} #### Tableau installé #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	whiptail --title "IP Adresse" --msgbox "Tableau de Bord installé. Noter bien l'adresse IP $eth_ip ou $wan_ip" 8 78
	cd /home/pi

	 # clear
	echo -e "$(date)" "${GREEN} #### Définir du Noed #### ${NORMAL}" | sudo tee -a  /var/log/install.log
source "${BASH_SOURCE%/*}/functions/node_setup_fr.sh"
nodeset
#### Removal of unwanted files ####
	echo -e "$(date)" "${YELLOW} #### Removing unwanted files #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	source "${BASH_SOURCE%/*}/functions/deletion.sh"
	delete
#### Identification setup ####
	echo -e "$(date)" "${GREEN} #### Identification setup  #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	source "${BASH_SOURCE%/*}/functions/announce_fr.sh"
	announce
	echo -e "$(date)" "${GREEN} #### Announcement setup complete  #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	source "${BASH_SOURCE%/*}/functions/tones_fr.sh"
	tones
	echo -e "$(date)" "${GREEN} #### Tones setup complete  #### ${NORMAL}" | sudo tee -a  /var/log/install.log	
	cd /home/pi	
	# clear
	echo -e "$(date)" "${RED} #### Changement du ModuleMetar #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	source "${BASH_SOURCE%/*}/functions/modulemetar_setup_fr.sh"
	modulemetar
	
	 # clear
	 cd /home/pi
	echo -e "$(date)" "${RED} #### Changement du ModuleEchoLink #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	source "${BASH_SOURCE%/*}/functions/echolink_setup_fr.sh"
	echolinksetup
	
	 # clear
#	echo -e "$(date)" "${RED} #### Changement du ModulePropagationMonitor #### ${NORMAL}" | sudo tee -a  /var/log/install.log
#	source "${BASH_SOURCE%/*}/functions/propagationmonitor_setup.sh"
#	propagationmonitor
	
	 # clear
	echo -e "$(date)" "${RED} #### Définir du svxlink.service #### ${NORMAL}" | sudo tee -a  /var/log/install.log

 	sudo systemctl enable svxlink_gpio_setup
	
 	sudo systemctl enable svxlink
	
 	sudo systemctl start svxlink_gpio_setup.service
	
 	sudo systemctl start svxlink.service


echo -e "$(date)" "${GREEN} #### Installation complète #### ${NORMAL}" | sudo tee -a  /var/log/install.log

echo -e "$(date)" "${RED} #### SVXLink est prêt  - allez au Tableau #### ${NORMAL}" | sudo tee -a  /var/log/install.log

#exit


 


	
 
