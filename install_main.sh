#!/bin/bash
#### Define Variables ####
CONF="/etc/svxlink/svxlink.conf"
MODULE="/etc/svxlink/svxlink.d"
OP="/etc/svxlink"
#### Welcome Message ####
source "${BASH_SOURCE%/*}/functions/welcome.sh"
welcome
echo "Welcome Message" | sudo tee -a  /var/log/install.log
source "${BASH_SOURCE%/*}/functions/configure.sh"
configure
echo "Configuration Message" | sudo tee -a  /var/log/install.log
#### TEST for SA818 ####
source "${BASH_SOURCE%/*}/functions/sa818_test.sh"
sa818_test
echo "SA818 Test complete" | sudo tee -a  /var/log/install.log
if [[ $sa818 == true ]]; then
source "${BASH_SOURCE%/*}/functions/sa818_menu.sh"
sa818_menu
echo "SA818 Configuration complete" | tee -a  /var/log/install.log
else
echo "No SA818 device" |tee -a  /var/log/install.log
fi
#### USB SOUND CARD ####
source "${BASH_SOURCE%/*}/functions/sound_card.sh"
soundcard
echo "Sound Card Selection complete" | sudo tee -a  /var/log/install.log
#### GROUPS AND USERS ####
# clear
echo -e "$(date)" "${YELLOW} #### Creating Groups and Users #### ${NORMAL}" | sudo tee -a  /var/log/install.log
source "${BASH_SOURCE%/*}/functions/groups.sh"
make_groups
echo "Groups and Users created" | sudo tee -a  /var/log/install.log
#### REQUEST CALLSIGN ####
source "${BASH_SOURCE%/*}/functions/callsign.sh"
callsign
echo -e "$(date)" "${YELLOW} #### Callsign set to: $CALL #### ${NORMAL}" | sudo tee -a  /var/log/install.log
#### NODE Selection ####
source "${BASH_SOURCE%/*}/functions/node_type.sh"
nodeoption
echo -e "$(date)" "${YELLOW} #### Node Type: $NODE_OPTION #### ${NORMAL}" | sudo tee -a  /var/log/install.log

echo -e "$(date)" "${YELLOW} #### Sound Card: $HID $GPIOD $card #### ${NORMAL}" | sudo tee -a  /var/log/install.log	
echo -e "$(date)" "${YELLOW} #### Checking Alsa #### ${NORMAL}" | sudo tee -a  /var/log/install.log
#### NODE SVXREFLECTOR URL SELECTION ####
if [[ $NODE_OPTION == "2" || $NODE_OPTION == "4" ]]; then
source "${BASH_SOURCE%/*}/functions/reflector.sh"
reflector
echo -e "$(date)" "${YELLOW} #### SvxReflector URL set to: $SVXREFLECTOR_URL #### ${NORMAL}" | sudo tee -a  /var/log/install.log
fi
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
echo -e "$(date)" "${GREEN} #### Voice Files Installed for $lang #### ${NORMAL}" | sudo tee -a  /var/log/install.log
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
echo -e "$(date)" "${GREEN} #### Sudoers file created/updated for svxlink #### ${NORMAL}" | sudo tee -a  /var/log/install.log
 	echo -e "$(date)" "${RED} #### Downloading prepared configuration files from the scripts #### ${NORMAL}" | sudo tee -a  /var/log/install.log
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
	echo -e "$(date)" "${GREEN} #### Configuration files downloaded and in place #### ${NORMAL}" | sudo tee -a  /var/log/install.log
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
echo -e "$(date)" "${GREEN} #### Customisation complete #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	#### INSTALLING DASHBOARD ####
 # clear
	cd /home/pi
	echo -e "$(date)" "${YELLOW} #### Checking IP Addresses #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	
	source "${BASH_SOURCE%/*}/functions/get_ip.sh"
	ipaddress
	echo -e "$(date)" "${GREEN} #### IP Addresses found: $ip_address on $device #### ${NORMAL}" | sudo tee -a  /var/log/install.log
 # clear
	cd /home/pi
	echo -e "$(date)" "${YELLOW} #### Installing Dashboard #### ${NORMAL}" | sudo tee -a  /var/log/install.log

	source "${BASH_SOURCE%/*}/functions/dash_install.sh"
	dash_install
 # clear
	echo -e "$(date)" "${GREEN} #### Dashboard installed #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	whiptail --title "IP Addresses" --msgbox "Dashboard installed. Please note your IP address is $ip_address on $device" 8 78
	IP=$ip_address
	export IP
	cd /home/pi/

	 # clear
	echo -e "$(date)" "${GREEN} #### Setting up Node #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	source "${BASH_SOURCE%/*}/functions/node_setup.sh"
	nodeset
	echo -e "$(date)" "${GREEN} #### Node setup complete #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	 # clear
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
	echo -e "$(date)" "${RED} #### ModuleMetar setup complete #### ${NORMAL}" | sudo tee -a  /var/log/install.log	
	 # clear
	 cd /home/pi/
	echo -e "$(date)" "${RED} #### Changing ModuleEchoLink Link #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	source "${BASH_SOURCE%/*}/functions/echolink_setup.sh"
	echolinksetup
	echo -e "$(date)" "${RED} #### ModuleEchoLink setup as required #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	 # clear
#	echo -e "$(date)" "${RED} #### Changing ModulePropagationMonitor #### ${NORMAL}" | sudo tee -a  /var/log/install.log
#	source "${BASH_SOURCE%/*}/functions/propagationmonitor_setup.sh"
#	propagationmonitor
	echo "Unused logic module: $NOT_LOGIC_MODULE" | sudo tee -a  /var/log/install.log
#sudo sed -i '/^\['"$NOT_LOGIC_MODULE"'\]/,/^\[/ { /^\['"$NOT_LOGIC_MODULE"'\]/d; /^\[/!d }' /etc/svxlink/svxlink.conf
# Trim whitespace and remove CRs from module name
NOT_LOGIC_MODULE="$(echo -n "$NOT_LOGIC_MODULE" | tr -d '\r' | xargs)"

# Check that the section exists
if ! grep -q "^\[$NOT_LOGIC_MODULE\]" "$CONF"; then
    echo "Module [$NOT_LOGIC_MODULE] not found in $CONF"
else echo "Module [$NOT_LOGIC_MODULE] found in $CONF, proceeding to remove it." | sudo tee -a  /var/log/install.log	 
fi

# Remove the section safely
sed -i "/^\[$NOT_LOGIC_MODULE\]/,/^\[/{
    /^\[$NOT_LOGIC_MODULE\]/d
    /^\[/!d
}" "$CONF"
	if grep -q "^\[$NOT_LOGIC_MODULE\]" "$CONF"; then
	echo "Failed to remove module [$NOT_LOGIC_MODULE] from $CONF" | sudo tee -a  /var/log/install.log
	fi
	 # clear
	echo -e "$(date)" "${RED} #### Unwanted Module $NOT_LOGIC_MODULE is removed #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	 # clear
	echo -e "$(date)" "${RED} #### Restarting svxlink.service #### ${NORMAL}" | sudo tee -a  /var/log/install.log
	
 	sudo systemctl restart svxlink apache2 svxlink-node 
echo -e "$(date)" "${GREEN} #### Services restarted #### ${NORMAL}" | sudo tee -a  /var/log/install.log

	##.service isn't necessary ##
echo -e "$(date)" "${GREEN} #### Installation complete #### ${NORMAL}" | sudo tee -a  /var/log/install.log
whiptail --title "Installation Complete" --msgbox "Installation complete. Go to the Dashboard, Your IP address $IP has been placed in the dhcpcd.conf" 8 78
echo -e "$(date)" "${RED} #### Complete #### ${NORMAL}" | sudo tee -a  /var/log/install.log

#exit

 


	
 
