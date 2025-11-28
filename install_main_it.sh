#!/bin/bash
lang=$(echo $LANG | grep -o '^[a-zA-Z]*_[a-zA-Z]*')
#### Define Variables ####
CONF="/etc/svxlink/svxlink.conf"
MODULE="/etc/svxlink/svxlink.d"
OP="/etc/svxlink"
export HOME
#### Welcome Message ####
source "${BASH_SOURCE%/*}/functions/welcome_it.sh"
welcome
source "${BASH_SOURCE%/*}/functions/configure_it.sh"
configure
#### TEST for SA818 ####
source "${BASH_SOURCE%/*}/functions/sa818_test_it.sh"
sa818_test
if [[ $sa818 == true ]]; then
source "${BASH_SOURCE%/*}/functions/sa818_menu_it.sh"
sa818_menu
else
echo "Nessun dispositivo SA818" | sudo tee -a /var/log/install.log > /dev/null
fi
#### USB SOUND CARD ####
source "${BASH_SOURCE%/*}/functions/sound_card_it.sh"
soundcard
#### NODE Selection ####
source "${BASH_SOURCE%/*}/functions/node_type_it.sh"
nodeoption
echo -e "$(date)" "${YELLOW} #### Tipo di nodo: $NODEOPTION #### ${NORMAL}" | sudo tee -a /var/log/install.log > /dev/null

echo -e "$(date)" "${YELLOW} #### Scheda audio: $HID $GPIOD $card #### ${NORMAL}" | sudo tee -a /var/log/install.log > /dev/null
echo -e "$(date)" "${YELLOW} #### Verifica Alsa #### ${NORMAL}" | sudo tee -a /var/log/install.log > /dev/null

#### REQUEST CALLSIGN ####
source "${BASH_SOURCE%/*}/functions/callsign_it.sh"
callsign
#### GROUPS AND USERS ####
# clear
echo -e "$(date)" "${YELLOW} #### Creazione dei gruppi e degli utenti #### ${NORMAL}" | sudo tee -a /var/log/install.log > /dev/null
source "${BASH_SOURCE%/*}/functions/groups.sh"
make_groups

#### CONFIGURATION VOICES ####
 # clear
	echo -e "$(date)" "${GREEN} #### Installazione dei file vocali #### ${NORMAL}" | sudo tee -a /var/log/install.log > /dev/null

 	cd /usr/share/svxlink/sounds
	
	sudo git clone https://github.com/ik4nzd/Suoni-in-italiano-per-SvxLink.git it_IT

  	cd /etc/svxlink
   sudo chmod 775 -R *

#### BACKUP CONFIGURATION ####
 # clear
	echo -e "$(date)" "${GREEN} #### Backup della configurazione in : $CONF.bak #### ${NORMAL}"| sudo tee -a /var/log/install.log > /dev/null

 	if [ -f "$CONF" ]; then
    sudo cp -p "$CONF" "$CONF.bak"
else
    echo "Il file $CONF non esiste."
fi

##
 	cd /home/pi/
	SUDOERS_FILE="/etc/sudoers.d/svxlink"
	SOURCE_FILE="svxlinkbuilder/www-data.sudoers"
	if [ ! -f "$SOURCE_FILE" ]; then
  whiptail --title "Errore" --msgbox "Il file sorgente $SOURCE_FILE non esiste. Uscita dal programma." 8 78
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
 	echo -e "$(date)" "${RED} #### Download dei file di configurazione preparati dagli script #### ${NORMAL}" | sudo tee -a /var/log/install.log > /dev/null
	sudo mkdir -p /home/pi/scripts
	sudo cp -f /home/pi/svxlinkbuilder/addons/10-uname /etc/update-motd.d/
 	sudo cp -f /home/pi/svxlinkbuilder/configs/svxlink.conf /etc/svxlink/
	sudo cp -f /home/pi/svxlinkbuilder/addons/node_info.json /etc/svxlink/node_info.json
 	sudo cp -f /home/pi/svxlinkbuilder/resetlog.sh /home/pi/scripts/resetlog.sh
	sudo cp -f /home/pi/svxlinkbuilder/dtmf_setup.sh /home/pi/scripts/dtmf_setup.sh
 	(sudo crontab -l 2>/dev/null; echo "59 23 * * * /home/pi/scripts/resetlog.sh " ; echo "@reboot /home/pi/scripts/dtmf_setup.sh") | sudo crontab -
	sudo mkdir -p /usr/share/svxlink/events.d/local
	sudo cp /usr/share/svxlink/events.d/RepeaterLogicType.tcl /usr/share/svxlink/events.d/local/
    sudo cp /usr/share/svxlink/events.d/CW.tcl /usr/share/svxlink/events.d/local/
    sudo cp /usr/share/svxlink/events.d/Logic.tcl /usr/share/svxlink/events.d/local/
    # clear
	echo -e "$(date)" "${GREEN} #### Nominativo impostato su $CALL #### ${NORMAL}" | sudo tee -a /var/log/install.log > /dev/null

 	sudo sed -i "s/MYCALL/$CALL/g" $CONF
 	sudo sed -i "s/MYCALL/$CALL/g" /etc/svxlink/node_info.json

	echo -e "$(date)" "${GREEN} #### Impostazione dello Squelch Hangtime a 10 ms #### ${NORMAL}" | sudo tee -a /var/log/install.log > /dev/null
 	sudo sed -i s/SQL_HANGTIME=2000/SQL_HANGTIME=10/g $CONF
 
 # clear	
	echo -e "$(date)" "${YELLOW} #### Disabilitazione dei messaggi di avviso della distorsione audio #### ${NORMAL}"| sudo tee -a /var/log/install.log > /dev/null


 	sudo sed -i 's/PEAK_METER=1/PEAK_METER=0/g' $CONF

 # clear
	echo -e "$(date)" "${GREEN} #### Aggiornamento dello SplashScreen all'avvio #### ${NORMAL}" | sudo tee -a /var/log/install.log > /dev/null

 	sudo sed -i "s/MYCALL/$CALL/g" /etc/update-motd.d/10-uname
 	sudo chmod 0775 /etc/update-motd.d/10-uname

 # clear
	echo -e "$(date)" "${YELLOW} #### Modifica del suffisso del file di log #### ${NORMAL}" | sudo tee -a /var/log/install.log > /dev/null

 	sudo sed -i '/^LOGFILE=/ { /[^.log]$/ s/$/.log/ }' /etc/default/svxlink

	#### INSTALLING DASHBOARD ####
 # clear
	cd /home/pi
	echo -e "$(date)" "${YELLOW} #### Verifica degli indirizzi IP #### ${NORMAL}" | sudo tee -a /var/log/install.log > /dev/null
	
	source "${BASH_SOURCE%/*}/functions/get_ip.sh"
	ipaddress
 # clear
	cd /home/pi
	echo -e "$(date)" "${YELLOW} #### Installazione della dashboard #### ${NORMAL}" | sudo tee -a /var/log/install.log > /dev/null

	source "${BASH_SOURCE%/*}/functions/dash_install_it.sh"
	dash_install
 # clear
	echo -e "$(date)" "${GREEN} #### Dashboard installata #### ${NORMAL}" | sudo tee -a /var/log/install.log > /dev/null
	whiptail --title "Indirizzo IP" --msgbox "La dashboard è stata installata. Il tuo indirizzo IP è $ip_address su $device" 8 78
	IP=$ip_address
	export IP
	cd /home/pi/

	 # clear
	echo -e "$(date)" "${GREEN} #### Configurazione del nodo #### ${NORMAL}" | sudo tee -a /var/log/install.log > /dev/null
	source "${BASH_SOURCE%/*}/functions/node_setup_it.sh"
	nodeset
	#### Removal of unwanted files ####
	#echo -e "$(date)" "${YELLOW} #### Removing unwanted files #### ${NORMAL}" | sudo tee -a /var/log/install.log > /dev/null
	#source "${BASH_SOURCE%/*}/functions/deletion.sh"
	#delete
	#### TIME SELECTION ####
    source "${BASH_SOURCE%/*}/functions/time_selection_it.sh"
    timeselect
	#### Identification setup ####
	echo -e "$(date)" "${GREEN} #### Configurazione dell'identificazione  #### ${NORMAL}" | sudo tee -a /var/log/install.log > /dev/null
	source "${BASH_SOURCE%/*}/functions/announce_it.sh"
	announce
	echo -e "$(date)" "${GREEN} #### Configurazione degli annunci completata  #### ${NORMAL}" | sudo tee -a /var/log/install.log > /dev/null
	source "${BASH_SOURCE%/*}/functions/tones_it.sh"
	tones
	echo -e "$(date)" "${GREEN} #### Configurazione dei toni completata  #### ${NORMAL}" | sudo tee -a /var/log/install.log > /dev/null
	cd /home/pi
	 # clear
 	echo -e "$(date)" "${RED} #### Modifica del collegamento ModuleMetar #### ${NORMAL}" | sudo tee -a /var/log/install.log > /dev/null
	
	
	## geting Italian Airports
	source "${BASH_SOURCE%/*}/functions/modulemetar_setup_it.sh"
	modulemetar
		
	 # clear
	 cd /home/pi/
	echo -e "$(date)" "${RED} #### Modifica del collegamento ModuleEchoLink #### ${NORMAL}" | sudo tee -a /var/log/install.log > /dev/null
	source "${BASH_SOURCE%/*}/functions/echolink_setup_it.sh"
	echolinksetup
	
	 # clear
#	echo -e "$(date)" "${RED} #### Changing ModulePropagationMonitor #### ${NORMAL}" | sudo tee -a /var/log/install.log > /dev/null
#	source "${BASH_SOURCE%/*}/functions/propagationmonitor_setup.sh"
#	propagationmonitor
	echo "Modulo logico non utilizzato: $NOT_LOGIC_MODULE" | sudo tee -a /var/log/install.log > /dev/null
#sudo sed -i '/^\['"$NOT_LOGIC_MODULE"'\]/,/^\[/ { /^\['"$NOT_LOGIC_MODULE"'\]/d; /^\[/!d }' /etc/svxlink/svxlink.conf
# Trim whitespace and remove CRs from module name
NOT_LOGIC_MODULE="$(echo -n "$NOT_LOGIC_MODULE" | tr -d '\r' | xargs)"

# Check that the section exists
if ! grep -q "^\[$NOT_LOGIC_MODULE\]" "$CONF"; then
    echo "Il modulo [$NOT_LOGIC_MODULE] non è presente in $CONF"
else echo "Il modulo [$NOT_LOGIC_MODULE] è presente in $CONF, procedo a rimuoverlo." | sudo tee -a /var/log/install.log > /dev/null
fi

# Remove the section safely
sed -i "/^\[$NOT_LOGIC_MODULE\]/,/^\[/{
    /^\[$NOT_LOGIC_MODULE\]/d
    /^\[/!d
}" "$CONF"
	if grep -q "^\[$NOT_LOGIC_MODULE\]" "$CONF"; then
	echo "Impossibile rimuovere il modulo [$NOT_LOGIC_MODULE] da $CONF" | sudo tee -a /var/log/install.log > /dev/null
	fi
	 # clear
	echo -e "$(date)" "${RED} #### Riavvio di svxlink.service #### ${NORMAL}" | sudo tee -a /var/log/install.log > /dev/null
	
 	sudo systemctl restart svxlink apache2 svxlink-node 

	##.service isn't necessary ##
echo -e "$(date)" "${GREEN} #### Installazione completata #### ${NORMAL}" | sudo tee -a /var/log/install.log > /dev/null
whiptail --title "Installazione completata" --msgbox "L'installazione è stata completata. Vai alla dashboard. Il tuo indirizzo IP $IP è stato inserito nel file dhcpcd.conf" 8 78
echo -e "$(date)" "${RED} #### Installazione completata #### ${NORMAL}" | sudo tee -a /var/log/install.log > /dev/null

#exit

 


	
 
