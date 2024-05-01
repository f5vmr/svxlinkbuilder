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
echo -e "$(date)" "${YELLOW} #### Type du Noed: $NODEOPTION #### ${NORMAL}" | tee -a  /var/log/install.log
#### USB SOUND CARD ####
source "${BASH_SOURCE%/*}/functions/sound_card_fr.sh"
soundcard
echo -e "$(date)" "${YELLOW} #### Carte de son : $HID $GPIOD $card #### ${NORMAL}" | tee -a  /var/log/install.log	
echo -e "$(date)" "${YELLOW} #### Verification d'Alsa #### ${NORMAL}" | tee -a  /var/log/install.log
#### UPDATE ####
source "${BASH_SOURCE%/*}/functions/update_fr.sh"
update
#### REQUEST CALLSIGN ####
source "${BASH_SOURCE%/*}/functions/callsign_fr.sh"
callsign
#### GROUPS AND USERS ####
clear
echo -e "$(date)" "${YELLOW} #### Creation des Groupes and Users #### ${NORMAL}" | tee -a  /var/log/install.log
source "${BASH_SOURCE%/*}/functions/groups.sh"
 make_groups
#### DOWNLOADING SOURCE CODE ####
echo -e "$(date)" "${YELLOW} #### Téléchargement du code source du SVXLink #### ${NORMAL}" | tee -a  /var/log/install.log
source "${BASH_SOURCE%/*}/functions/source.sh"
 svxlink_source	
#### INSTALLATION ####
 # clear
 	NEWVERSION=$(sudo grep -r "SVXLINK=" "svxlink"/* | awk -F= '{print $2}')
	echo -e "$(date)" "${GREEN} #### New Version: $NEWVERSION #### ${NORMAL}" | tee -a  /var/log/install.log

	
#### COMPILING ####
 # clear
	echo -e "$(date)" "${YELLOW} #### Compilation #### ${NORMAL}" | tee -a  /var/log/install.log

 	cd svxlink/src/build
 	sudo cmake -DUSE_QT=OFF -DCMAKE_INSTALL_PREFIX=/usr -DSYSCONF_INSTALL_DIR=/etc -DLOCAL_STATE_DIR=/var -DWITH_SYSTEMD=ON  ..
 	sudo make
 	sudo make doc
 	echo -e "$(date)" "${GREEN} #### Installation SVXLink #### ${NORMAL}" | tee -a  /var/log/install.log
 	sudo make install
 	cd /usr/share/svxlink/events.d
 	sudo mkdir local
 	sudo cp *.tcl ./local
 	sudo ldconfig
#### CONFIGURATION VOICES ####
 # clear
	echo -e "$(date)" "${GREEN} #### Installation des dossiers de Voix  #### ${NORMAL}" | tee -a  /var/log/install.log

 	cd /usr/share/svxlink/sounds
 	sudo wget https://g4nab.co.uk/wp-content/uploads/2023/08/fr_FR.tar_.gz
 	sudo tar -zxvf fr_FR.tar_.gz
 	sudo rm fr_FR.tar_.gz
  	cd /etc/svxlink
   sudo chmod 777 -R *

#### BACKUP CONFIGURATION ####
 # clear
	echo -e "$(date)" "${GREEN} #### Sauvegarder la configuration à : $CONF.bak #### ${NORMAL}"| tee -a  /var/log/install.log

 	sudo cp -p $CONF $CONF.bak
##
 	cd /home/pi
 	echo -e "$(date)" "${RED} #### Téléchargement de Dossiers de configuration du scripts #### ${NORMAL}" | tee -a  /var/log/install.log
 	sudo mkdir /home/pi/scripts
 	sudo cp -f /home/pi/svxlinkbuilder/addons/10-uname /etc/update-motd.d/
 	sudo cp -f /home/pi/svxlinkbuilder/configs/svxlink.conf /etc/svxlink/
 	sudo cp -f /home/pi/svxlinkbuilder/configs/gpio.conf /etc/svxlink/
 	sudo cp -f /home/pi/svxlinkbuilder/addons/node_info.json /etc/svxlink/node_info.json
 	sudo cp -f /home/pi/svxlinkbuilder/resetlog.sh /home/pi/scripts/resetlog.sh
 	(sudo crontab -l 2>/dev/null; echo "59 23 * * * /home/pi/scripts/resetlog.sh ") | sudo crontab -
 # clear
	echo -e "$(date)" "${GREEN} #### Définir l'indicatif d'appel sur $CALL #### ${NORMAL}" | tee -a  /var/log/install.log

 	sudo sed -i "s/MYCALL/$CALL/g" $CONF
 	sudo sed -i "s/MYCALL/$CALL/g" /etc/svxlink/node_info.json
 	echo -e "$(date)" "${GREEN} #### Setting Squelch Hangtime t*o 10 mS ${NORMAL}" | tee -a  /var/log/install.log
 	sudo sed -i 's/SQL_HANGTIME=2000/SQL_HANGTIME=10/g' $CONF
 # clear	
	echo -e "$(date)" "${YELLOW} #### Désactivation des messages d'avertissement de distorsion audio #### ${NORMAL}"| tee -a  /var/log/install.log


 	sudo sed -i 's/PEAK_METER=1/PEAK_METER=0/g' $CONF
 # clear
	echo -e "$(date)" "${GREEN} #### Mise à jour de SplashScreen au démarrage #### ${NORMAL}" | tee -a  /var/log/install.log

 	sudo sed -i "s/MYCALL/$CALL/g" /etc/update-motd.d/10-uname
 	sudo chmod 0755 /etc/update-motd.d/10-uname
 #
 # clear
	echo -e "$(date)" "${YELLOW} #### Modification du suffixe du fichier journal ${NORMAL}" | tee -a  /var/log/install.log

 	sudo sed -i 's/log\/svxlink/log\/svxlink.log/g' /etc/default/svxlink
	#### INSTALLING DASHBOARD ####
 # clear
	cd /home/pi
	echo -e "$(date)" "${YELLOW} #### Vérification des adresses IP #### ${NORMAL}" | tee -a  /var/log/install.log
	
	source "${BASH_SOURCE%/*}/functions/get_ip.sh"
	ipaddress
 # clear
	cd /home/pi
	echo -e "$(date)" "${YELLOW} #### Installing Tableau de Bord #### ${NORMAL}" | tee -a  /var/log/install.log

	source "${BASH_SOURCE%/*}/functions/dash_install_fr.sh"
install_dash
 # clear
	echo -e "$(date)" "${GREEN} #### Tableau installé #### ${NORMAL}" | tee -a  /var/log/install.log
	whiptail --title "IP Addresses" --msgbox "Tableau de Bord installé. Noter bien l'adresse IP $eth_ip ou $wan_ip" 8 78
	cd /home/pi

	 # clear
	echo -e "$(date)" "${GREEN} #### Définir du Noed #### ${NORMAL}" | tee -a  /var/log/install.log
source "${BASH_SOURCE%/*}/functions/node_setup_fr.sh"
nodeset
echo -e "$(date)" "${RED} #### Changement du ModuleMetar #### ${NORMAL}" | tee -a  /var/log/install.log
source "${BASH_SOURCE%/*}/functions/modulemetar_setup_fr.sh"
modulemetar
	
	 # clear
	
	 # clear
	echo -e "$(date)" "${RED} #### Changement du ModuleEchoLink #### ${NORMAL}" | tee -a  /var/log/install.log
source "${BASH_SOURCE%/*}/functions/echolink_setup_fr.sh"
echolinksetup
	
	 # clear
#	echo -e "$(date)" "${RED} #### Changement du ModulePropagationMonitor #### ${NORMAL}" | tee -a  /var/log/install.log
#	source "${BASH_SOURCE%/*}/functions/propagationmonitor_setup.sh"
#	propagationmonitor
	
	 # clear
	echo -e "$(date)" "${RED} #### Définir du svxlink.service #### ${NORMAL}" | tee -a  /var/log/install.log

 	sudo systemctl enable svxlink_gpio_setup
	
 	sudo systemctl enable svxlink
	
 	sudo systemctl start svxlink_gpio_setup.service
	
 	sudo systemctl start svxlink.service


echo -e "$(date)" "${GREEN} #### Installation complète #### ${NORMAL}" | tee -a  /var/log/install.log

echo -e "$(date)" "${RED} #### Rebooting SVXLink #### ${NORMAL}" | tee -a  /var/log/install.log

#exit


 sudo reboot


	
 
