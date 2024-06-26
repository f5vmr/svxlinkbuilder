#!/bin/bash
function update {
CONF="/etc/svxlink/svxlink.conf"
GPIO="/etc/svxlink/gpio.conf"
OP=/etc/svxlink


	VERSIONS=svxlink/src/versions | sudo tee -a   /var/log/install.log   

	echo -e "$(date)" "${YELLOW} #### commence build #### ${NORMAL}" | sudo tee -a  /var/log/install.log
#### BUILD ESSENTIALS ####
	whiptail --title "Construir elementos esenciales" --msgbox "Agregue todos los paquetes necesarios para Svxlink. Escribe OK para continuar" 8 78

	echo -e "$(date)" "${YELLOW} ### Installation of Packages ### ${NORMAL}" | sudo tee -a  /var/log/install.log
 	sudo apt-get install apache2 apache2-bin apache2-data apache2-utils php8.2  python3-serial sqlite3 php8.2-sqlite3 toilet -y

}