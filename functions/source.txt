#!/bin/bash
function svxlink_source {
    
    echo -e "$(date)" "${YELLOW} Svxlink_source is SvxLink from SM0SVX ${NORMAL}" | tee -a /var/log/install.log
    cd /home/pi/
    sudo git clone https://github.com/sm0svx/svxlink.git
	sudo mkdir svxlink/src/build
}