#!/bin/bash
function update {
CONF="/etc/svxlink/svxlink.conf"
GPIO="/etc/svxlink/gpio.conf"
OP=/etc/svxlink

whiptail --title "Actualizado" --msgbox "Directorios actualizados para nodo js y expansión para el futuro. Escribe OK para continuar" 8 78

	echo -e "$(date)" "${YELLOW}  #### updates and upgrades #### ${NORMAL}" | tee -a  /var/log/install.log

 	sudo apt-get update
 	sudo apt-get upgrade -y
	VERSIONS=svxlink/src/versions | tee -a   /var/log/install.log   

	echo -e "$(date)" "${YELLOW}  #### commence build #### ${NORMAL}" | tee -a  /var/log/install.log
###### BUILD ESSENTIALS ####
	whiptail --title "Construir elementos esenciales" --msgbox "Agregue todos los paquetes necesarios para Svxlink. Escribe OK para continuar" 8 78

	echo -e "$(date)" "${YELLOW} ### Instalación de paquetes ### ${NORMAL}" | tee -a  /var/log/install.log
 	sudo apt-get install build-essential g++ make cmake libsigc++-2.0-dev php8.2 nodejs libgsm1-dev libudev-dev libpopt-dev tcl-dev libgpiod-dev gpiod libgcrypt20-dev libspeex-dev libasound2-dev alsa-utils libjsoncpp-dev libopus-dev rtl-sdr libcurl4-openssl-dev libogg-dev librtlsdr-dev groff doxygen graphviz python3-serial sqlite3 php8.2-sqlite3 toilet -y

}