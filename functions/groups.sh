#!/bin/bash
function make_groups {
   echo -e "$(date)" "${YELLOW} #### Creating Groups and Users #### ${NORMAL}" | sudo tee -a  /var/log/install.log
 	sudo mkdir -p /etc/svxlink
    sudo groupadd svxlink
 	sudo useradd -g svxlink -d /etc/svxlink svxlink
 	sudo usermod -aG audio,nogroup,svxlink,plugdev svxlink
	sudo usermod -aG gpio svxlink
}
	