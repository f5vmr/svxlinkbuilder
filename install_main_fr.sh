#!/bin/bash
lang=$(echo $LANG | grep -o '^[a-zA-Z]*_[a-zA-Z]*')
#### Define Variables ####
CONF="/etc/svxlink/svxlink.conf"
MODULE="/etc/svxlink/svxlink.d"
OP=/etc/svxlink
export HOME
#### Welcome Message ####
source "${BASH_SOURCE%/*}/functions/welcome_fr.sh"
welcome
source "${BASH_SOURCE%/*}/functions/configure_fr.sh"
configure_fr
#### USB SOUND CARD ####
source "${BASH_SOURCE%/*}/functions/sound_card_fr.sh"
soundcard
#### NODE Selection ####
source "${BASH_SOURCE%/*}/functions/node_type_fr.sh"
nodeoption
echo -e "$(date)" "${YELLOW} #### Type du Noeud: $NODEOPTION #### ${NORMAL}" | sudo tee -a  /var/log/install.log

echo -e "$(date)" "${YELLOW} #### Carte son : $HID $GPIOD $card #### ${NORMAL}" | sudo tee -a  /var/log/install.log	
echo -e "$(date)" "${YELLOW} #### Verification d'Alsa #### ${NORMAL}" | sudo tee -a  /var/log/install.log

#### REQUEST CALLSIGN ####
source "${BASH_SOURCE%/*}/functions/callsign_fr.sh"
callsign
#### GROUPS AND USERS ####
# clear
echo -e "$(date)" "${YELLOW} #### Creation des Groupes and Utilisateurs #### ${NORMAL}" | sudo tee -a  /var/log/install.log
source "${BASH_SOURCE%/*}/functions/groups.sh"
make_groups

#### CONFIGURATION VOICES ####
 # clear
	echo -e "$(date)" "${GREEN} #### Installation des fichiers sons (Voix)  #### ${NORMAL}" | sudo tee -a  /var/log/install.log

 	cd /usr/share/svxlink/sounds
 	sudo git clone https://github.com/f5vmr/fr_FR.git
  	cd /etc/svxlink
   sudo chmod 775 -R *

#### BACKUP CONFIGURATION ####
 # clear
	echo -e "$(date)" "${GREEN} #### Sauvegarder la configuration à : $CONF.bak #### ${NORMAL}"| sudo tee -a  /var/log/install.log

 	if [ -f "$CONF" ]; then
    sudo cp -p "$CONF" "$CONF.bak"
else
    echo "File $CONF n'existe pas."
fi

##
cd /home/pi/
	SUDOERS_FILE="/etc/sudoers.d/svxlink"
	SOURCE_FILE="svxlinkbuilder/www-data.sudoers"
	if [ ! -f "$SOURCE_FILE" ]; then
  whiptail --title "Error" --msgbox "Fichier source $SOURCE_FILE n'existe pas. Quitter." 8 78
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
 	sudo mkdir /home/pi/scripts
	sudo cp -f /home/pi/svxlinkbuilder/addons/10-uname /etc/update-motd.d/
 	sudo cp -f /home/pi/svxlinkbuilder/configs/svxlink.conf /etc/svxlink/
    sudo cp -f /home/pi/svxlinkbuilder/addons/node_info.json /etc/svxlink/node_info.json
 	sudo cp -f /home/pi/svxlinkbuilder/resetlog.sh /home/pi/scripts/resetlog.sh
 	(sudo crontab -l 2>/dev/null; echo "59 23 * * * /home/pi/scripts/resetlog.sh ") | sudo crontab -
    sudo mkdir /usr/share/svxlink/events.d/local
	sudo cp /usr/share/svxlink/events.d/*.tcl /usr/share/svxlink/events.d/local/
	sudo cp -f /home/pi/svxlinkbuilder/configs/Logic.tcl /usr/share/svxlink/events.d/local/Logic.tcl
	sudo sed -i '/^LINK=\/adds\/dataserver_current\/httpparam/ c\LINK=/cgi-bin/data/dataserver.php?requestType=retrieve&dataSource=metars&hoursBeforeNow=3&stationString=' $MODULE/ModuleMetarInfo.conf
 # clear
	echo -e "$(date)" "${GREEN} #### Indicatif à $CALL #### ${NORMAL}" | sudo tee -a  /var/log/install.log

 	sudo sed -i "s/MYCALL/$CALL/g" $CONF
 	sudo sed -i "s/MYCALL/$CALL/g" /etc/svxlink/node_info.json

	echo -e "$(date)" "${GREEN} ####  Squelch Hangtime à 10 mS ${NORMAL}" | sudo tee -a  /var/log/install.log
 	sudo sed -i s/SQL_HANGTIME=2000/SQL_HANGTIME=10/g $CONF
 
 # clear	
	echo -e "$(date)" "${YELLOW} #### Désactivation des messagess d'alertes de distortion #### ${NORMAL}"| sudo tee -a  /var/log/install.log


 	sudo sed -i 's/PEAK_METER=1/PEAK_METER=0/g' $CONF

 # clear
	echo -e "$(date)" "${GREEN} #### Mise à jour écran au demarrage #### ${NORMAL}" | sudo tee -a  /var/log/install.log

 	sudo sed -i "s/MYCALL/$CALL/g" /etc/update-motd.d/10-uname
 	sudo chmod 0775 /etc/update-motd.d/10-uname

 # clear
	echo -e "$(date)" "${YELLOW} #### Changement du suffix du Fichier Log ${NORMAL}" | sudo tee -a  /var/log/install.log

	sudo sed -i '/^LOGFILE=/ { /[^.log]$/ s/$/.log/ }' /etc/default/svxlink

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
	dash_install
 # clear
	echo -e "$(date)" "${GREEN} #### Tableau installé #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	whiptail --title "IP Adresse" --msgbox "Tableau de Bord installé. Noter bien l'adresse IP $ip_address sur $device" 8 78
	cd /home/pi

	 # clear
	echo -e "$(date)" "${GREEN} #### Définir du Noeud #### ${NORMAL}" | sudo tee -a  /var/log/install.log
source "${BASH_SOURCE%/*}/functions/node_setup_fr.sh"
nodeset
	#### Removal of unwanted files ####
	#echo -e "$(date)" "${YELLOW} #### Suppression des fichier Removing indésirables #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	#source "${BASH_SOURCE%/*}/functions/deletion.sh"
	#delete
	#### TIME SELECTION ####
    source "${BASH_SOURCE%/*}/functions/time_selection_fr.sh"
    timeselect
	#### Identification setup ####
	echo -e "$(date)" "${GREEN} #### Configuration des paramêtres d'identifications #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	source "${BASH_SOURCE%/*}/functions/announce_fr.sh"
	announce
	echo -e "$(date)" "${GREEN} #### Configuration des paramêtres d'annonces terminés  #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	source "${BASH_SOURCE%/*}/functions/tones_fr.sh"
	tones
	echo -e "$(date)" "${GREEN} #### Parametres des tonalités terminées  #### ${NORMAL}" | sudo tee -a  /var/log/install.log	
	cd /home/pi	
	# clear
	echo -e "$(date)" "${RED} #### Configuration du ModuleMetar (météo) #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	source "${BASH_SOURCE%/*}/functions/modulemetar_setup_fr.sh"
	modulemetar
	
	 # clear
	 cd /home/pi
	echo -e "$(date)" "${RED} #### Configuration du ModuleEchoLink #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	source "${BASH_SOURCE%/*}/functions/echolink_setup_fr.sh"
	echolinksetup
	
	 # clear
#	echo -e "$(date)" "${RED} #### Configuration du ModulePropagationMonitor #### ${NORMAL}" | sudo tee -a  /var/log/install.log
#	source "${BASH_SOURCE%/*}/functions/propagationmonitor_setup.sh"
#	propagationmonitor
	
	 # clear
	echo -e "$(date)" "${RED} #### Redemmarage du svxlink.service #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	
 	sudo systemctl restart svxlink.service

##.service isn't necessary ##

echo -e "$(date)" "${GREEN} #### Installation complète #### ${NORMAL}" | sudo tee -a  /var/log/install.log
whiptail --title "Installation terminée" --msgbox "Installation terminée. Allons-y au Tableau de bord" 8 78

echo -e "$(date)" "${RED} #### SVXLink est prêt  - allez au Tableau de bord (Dashboard)#### ${NORMAL}" | sudo tee -a  /var/log/install.log

#exit


 


	
 
