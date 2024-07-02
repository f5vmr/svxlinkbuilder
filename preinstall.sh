#/bin/bash
    cd /home/pi
    logname=$(whoami)
    #### INITIALISE ####
    source "${BASH_SOURCE%/*}/functions/initialise.sh"
    initialise
    #### CHECK OS ####
    source "${BASH_SOURCE%/*}/functions/check_os.sh"
    check_os
    #### CHECK USER ####
    source "${BASH_SOURCE%/*}/functions/check_user.sh"
    usercheck    
    ## Change swapfile size
    sudo dphys-swapfile swapoff 
    sudo sed -i 's/CONF_SWAPSIZE=100/CONF_SWAPSIZE=150/g' /etc/dphys-swapfile
    sudo dphys-swapfile swapon
    ## Install file manipulation pkg ##
    sudo apt-get install -y acl
    ## Set /var/log/install.log ##
    sudo touch /var/log/install.log
    sudo chmod 775 /var/log/install.log
    sudo setfacl -R -m u:pi:rwx /var/log/install.log
    ## Manipulation of Soundcards ##
    echo -e "${BLUE}#### Moving USB Soundcard to Position Card:0 ####{WHITE}" | sudo tee -a /var/log/install.log
    sudo chmod 777 /etc/modules
    sudo sh -c 'echo "blacklist snd_bcm2835" > /etc/modprobe.d/raspi-blacklist.conf'
    echo -e "${BLUE}#### Blacklisting snd_bcm 2835 ####{WHITE}" | sudo tee -a /var/log/install.log
    sudo sed -i 's/options snd-usb/\#options snd-usb/g' /lib/modprobe.d/aliases.conf
    echo -e "${BLUE}#### Disabling HMDI Sound - Not required for this build ####{WHITE}"| sudo tee -a /var/log/install.log
    sudo sed -i 's/dtoverlay=vc4-kms-v3d/dtoverlay=vc4-kms-v3d,noaudio/g' /boot/firmware/config.txt
    sudo cp -f /home/pi/svxlinkbuilder/configs/asound.conf /etc/modprobe.d/asound.conf
    echo -e "${BLUE}#### Setting up Loopback Soundcard ####{WHITE}" | sudo tee -a /var/log/install.log
    echo snd-aloop > /etc/modules
    sudo chmod 775 /etc/modules
    sudo cp -f /home/pi/svxlinkbuilder/configs/loopback.conf /etc/asound.conf
    echo -e "${BLUE}#### Reseting alsa-state.service ####{WHITE}" | sudo tee -a /var/log/install.log
    sudo mkdir /etc/alsa
    sudo touch /etc/alsa/state-daemon.conf
    sudo systemctl daemon-reload
    sudo systemctl restart alsa-state.service
    ## Install repository key and repository ##
    echo -e "${YELLOW}#### Installing repository key ####{WHITE}" | sudo tee -a /var/log/install.log
    sudo curl -O -q https://online-amateur-radio-club-m0ouk.github.io/oarc-packages/hibby.key
    sudo mv hibby.key /etc/apt/trusted.gpg.d/hibby.asc
    echo -e "${BLUE}#### Installing repository ####{WHITE}" | sudo tee -a /var/log/install.log
    echo "deb https://online-amateur-radio-club-m0ouk.github.io/oarc-packages bookworm main" | sudo tee -a /etc/apt/sources.list
    echo -e "${BLUE}#### Updating apt ####{WHITE}" | sudo tee -a /var/log/install.log
    sudo apt update && sudo apt upgrade -y
    ## Install svxlink-server  and dependencies ##
    echo -e "${BLUE}#### Installing svxlink-server ####{WHITE}" | sudo tee -a /var/log/install.log
    sudo apt install -y svxlink-server apache2 apache2-bin apache2-data apache2-utils php8.2 python3-serial sqlite3 php8.2-sqlite3 toilet libgpiod-dev -y
    echo -e "${BLUE}#### Installing locales ####{WHITE}" | sudo tee -a /var/log/install.log
    
    ## Must kill the remotetrx.service to avoid a problem later ##
    sudo systemctl stop remotetrx.service
    sudo systemctl disable remotetrx.service
    echo -e "${RED} #### remotetrx.service stopped #### ${NORMAL}" | sudo tee -a  /var/log/install.log 
    ## installing locales.##
    ## Set en_GB.UTF-8 as the default locale to begin with.##
    sudo localectl set-locale LANG=en_GB.UTF-8
    echo -e "${CYAN}Locale setup completed.${WHITE}"
    echo -e "${YELLOW}#### Your next command / prochain commande / próximo comando will be ${GREEN}./svxlinkbuilder/install.sh ####{WHITE}" | sudo tee -a /var/log/install.log
    echo -e "${GREEN}#### Login after Rebooting  then ${BLUE} ./svxlinkbuilder/install.sh ####{WHITE}" | sudo tee -a /var/log/install.log
    sudo shutdown -r now