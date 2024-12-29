#!/bin/bash
function make_groups {
   echo -e "$(date)" "${YELLOW} #### Creating Groups and Users #### ${NORMAL}" |  tee -a  /var/log/install.log
 	 mkdir /etc/svxlink
     groupadd svxlink
 	 useradd -g svxlink -d /etc/svxlink svxlink
 	 usermod -aG audio,nogroup,svxlink,plugdev svxlink
	 usermod -aG gpio svxlink
}
	