#!/bin/bash
function update {
CONF="/etc/svxlink/svxlink.conf"
GPIO="/etc/svxlink/gpio.conf"
OP=/etc/svxlink

whiptail --title "Mis à jour" --msgbox "Mise à jour des librairies actuelles pour nodejs et à l'avenir. Tapez OK pour continuer" 8 78

	echo -e "$(date)" "${YELLOW} #### updates and upgrades #### ${NORMAL}" | tee -a  /var/log/install.log

 	sudo apt-get update
 	sudo apt-get upgrade -y
	VERSIONS=svxlink/src/versions | tee -a   /var/log/install.log   

	echo -e "$(date)" "${YELLOW} #### Debut de la compilation  #### ${NORMAL}" | tee -a  /var/log/install.log
#### BUILD ESSENTIALS ####
	whiptail --title "Build Essentials" --msgbox "Ajoutez tous les paquets necessaires pour Svxlink. Tapez OK pour continuer" 8 78

	echo -e "$(date)" "${YELLOW} ### Installation des paquets ### ${NORMAL}" | tee -a  /var/log/install.log
 	sudo apt-get install build-essential g++ make cmake libsigc++-2.0-dev php8.2 nodejs libgsm1-dev libudev-dev libpopt-dev tcl-dev libgpiod-dev gpiod libgcrypt20-dev libspeex-dev libasound2-dev alsa-utils libjsoncpp-dev libopus-dev rtl-sdr libcurl4-openssl-dev libogg-dev librtlsdr-dev groff doxygen graphviz python3-serial sqlite3 php8.2-sqlite3 toilet -y