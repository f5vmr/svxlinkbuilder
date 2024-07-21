#!/bin/bash
lang=$(echo $LANG | grep -o '^[a-zA-Z]*_[a-zA-Z]*')
#### Define Variables ####
CONF="/etc/svxlink/svxlink.conf"
MODULE="/etc/svxlink/svxlink.d"
OP=/etc/svxlink
#### Welcome Message ####
source "${BASH_SOURCE%/*}/functions/welcome_es.sh"
welcome
source "${BASH_SOURCE%/*}/functions/configure_es.sh"
configure
#### USB SOUND CARD ####
source "${BASH_SOURCE%/*}/functions/sound_card_es.sh"
soundcard
#### NODE Selection ####
source "${BASH_SOURCE%/*}/functions/node_type_es.sh"
nodeoption
echo -e "$(date)" "${YELLOW} #### Node Type: $NODEOPTION #### ${NORMAL}" | sudo tee -a  /var/log/install.log

echo -e "$(date)" "${YELLOW} #### Sound Card: $HID $GPIOD $card #### ${NORMAL}" | sudo tee -a  /var/log/install.log	
echo -e "$(date)" "${YELLOW} #### Checking Alsa #### ${NORMAL}" | sudo tee -a  /var/log/install.log

#### REQUEST CALLSIGN ####
source "${BASH_SOURCE%/*}/functions/callsign_es.sh"
callsign
#### GROUPS AND USERS ####
clear
echo -e "$(date)" "${YELLOW} #### Creating Groups and Users #### ${NORMAL}" | sudo tee -a  /var/log/install.log
source "${BASH_SOURCE%/*}/functions/groups.sh"
make_groups


#### CONFIGURATION VOICES ####
 # clear
	echo -e "$(date)" "${GREEN} #### Installing Voice Files #### ${NORMAL}" | sudo tee -a  /var/log/install.log

 	cd /usr/share/svxlink/sounds

	sudo git clone https://github.com/ea5gvk/es_ES.git

  	cd /etc/svxlink
   sudo chmod 775 -R *

#### BACKUP CONFIGURATION ####
 # clear
	echo -e "$(date)" "${GREEN} #### Copia de seguridad de la configuración en: $CONF.bak #### ${NORMAL}"| sudo tee -a  /var/log/install.log

 	if [ -f "$CONF" ]; then
    sudo cp -p "$CONF" "$CONF.bak"
else
    echo "File $CONF does not exist."
fi

#
 	cd $HOME/
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

 	echo -e "$(date)" "${RED} #### Descarga de archivos de configuración preparados desde los scripts #### ${NORMAL}" | sudo tee -a  /var/log/install.log
 	sudo mkdir $HOME/scripts
	sudo cp -f $HOME/svxlinkbuilder/addons/10-uname /etc/update-motd.d/
 	sudo cp -f $HOME/svxlinkbuilder/configs/svxlink.conf /etc/svxlink/
 	sudo cp -f $HOME/svxlinkbuilder/configs/Logic.tcl /usr/share/svxlink/events.d/local/Logic.tcl
 	sudo cp -f $HOME/svxlinkbuilder/addons/node_info.json /etc/svxlink/node_info.json
 	sudo cp -f $HOME/svxlinkbuilder/resetlog.sh $HOME/scripts/resetlog.sh
 	(sudo crontab -l 2>/dev/null; echo "59 23 * * * $HOME/scripts/resetlog.sh ") | sudo crontab -
	sudo mkdir /usr/share/svxlink/events.d/local
	sudo cp /usr/share/svxlink/events.d/*.tcl /usr/share/svxlink/events.d/local/
    sudo sed -i 's|LINK=/adds/dataserver_current/httpparam?dataSource=metars&requestType=retrieve&format=xml&hoursBeforeNow=3&mostRecent=|LINK=/cgi-bin/data/dataserver.php?requestType=retrieve&dataSource=metars&hoursBeforeNow=3&stationString=|' $MODULE/ModuleMetarInfo.conf
 # clear
	echo -e "$(date)" "${GREEN} #### Establecer indicativo en $CALL #### ${NORMAL}" | sudo tee -a  /var/log/install.log

 	sudo sed -i "s/MYCALL/$CALL/g" $CONF
 	sudo sed -i "s/MYCALL/$CALL/g" /etc/svxlink/node_info.json

	echo -e "$(date)" "${GREEN} #### Configuración del tiempo de suspensión del silenciador en 10 mS ${NORMAL}" | sudo tee -a  /var/log/install.log
 	sudo sed -i s/SQL_HANGTIME=2000/SQL_HANGTIME=10/g $CONF
 
 # clear	
	echo -e "$(date)" "${YELLOW} #### Desactivar mensajes de advertencia de distorsión de audio #### ${NORMAL}"| sudo tee -a  /var/log/install.log


 	sudo sed -i 's/PEAK_METER=1/PEAK_METER=0/g' $CONF

 # clear
	echo -e "$(date)" "${GREEN} #### Actualización de SplashScreen al iniciar #### ${NORMAL}" | sudo tee -a  /var/log/install.log

 	sudo sed -i "s/MYCALL/$CALL/g" /etc/update-motd.d/10-uname
 	sudo chmod 0775 /etc/update-motd.d/10-uname

 # clear
	echo -e "$(date)" "${YELLOW} #### Cambiar el sufijo del archivo de registro ${NORMAL}" | sudo tee -a  /var/log/install.log

 		sudo sed -i '/^LOGFILE=/ { /[^.log]$/ s/$/.log/ }' /etc/default/svxlink

	#### INSTALLING DASHBOARD ####
 # clear
	cd $HOME
	echo -e "$(date)" "${YELLOW} #### Comprobación de direcciones IP #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	
	source "${BASH_SOURCE%/*}/functions/get_ip.sh"
	ipaddress
 # clear
	cd $HOME
	echo -e "$(date)" "${YELLOW} #### Instalación del panel #### ${NORMAL}" | sudo tee -a  /var/log/install.log

	source "${BASH_SOURCE%/*}/functions/dash_install_es.sh"
install_dash
 # clear
	echo -e "$(date)" "${GREEN} #### Panel instalado #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	whiptail --title "Adresses IP" --msgbox "Tablero instalado. Tenga en cuenta que su dirección IP es $ip_address en $device" 8 78
	cd $HOME/

	 # clear
	echo -e "$(date)" "${GREEN} #### Configurando el nodo #### ${NORMAL}" | sudo tee -a  /var/log/install.log
source "${BASH_SOURCE%/*}/functions/node_setup_es.sh"
nodeset
	#### Removal of unwanted files ####
	#echo -e "$(date)" "${YELLOW} #### Removing unwanted files #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	#source "${BASH_SOURCE%/*}/functions/deletion.sh"
	#delete
	#### Identification setup ####
	echo -e "$(date)" "${GREEN} #### Identification setup  #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	source "${BASH_SOURCE%/*}/functions/announce_es.sh"
	announce
	echo -e "$(date)" "${GREEN} #### Announcement setup complete  #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	source "${BASH_SOURCE%/*}/functions/tones_es.sh"
	tones
	echo -e "$(date)" "${GREEN} #### Tones setup complete  #### ${NORMAL}" | sudo tee -a  /var/log/install.log	
	
	cd $HOME
	 # clear
 	echo -e "$(date)" "${RED} #### Cambiando el móduloMetar Link #### ${NORMAL}" | sudo tee -a  /var/log/install.log
source "${BASH_SOURCE%/*}/functions/modulemetar_setup_es.sh"
modulemetar
	
	 # clear
	 cd $HOME/
	echo -e "$(date)" "${RED} #### Cambio de ModuleEchoLink  #### ${NORMAL}" | sudo tee -a  /var/log/install.log
source "${BASH_SOURCE%/*}/functions/echolink_setup_es.sh"
echolinksetup
	
	 # clear
#	echo -e "$(date)" "${RED} #### Changing ModulePropagationMonitor #### ${NORMAL}" | sudo tee -a  /var/log/install.log
#	source "${BASH_SOURCE%/*}/functions/propagationmonitor_setup.sh"
#	propagationmonitor
	
	 # clear
	echo -e "$(date)" "${RED} #### Reinicie svxlink.service #### ${NORMAL}" | sudo tee -a  /var/log/install.log

 	
	
 	sudo systemctl restart svxlink.service


echo -e "$(date)" "${GREEN} #### Instalación completa #### ${NORMAL}" | sudo tee -a  /var/log/install.log

echo -e "$(date)" "${RED} #### Complete #### ${NORMAL}" | sudo tee -a  /var/log/install.log

#exit




	
 
