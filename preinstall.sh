#/bin/bash
    cd /home/pi
    logname=$(whoami)
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
    ## Install file manipulation pkg
    sudo apt-get install -y acl
    ## Set /var/log/install.log
    sudo touch /var/log/install.log
    sudo chmod 777 /var/log/install.log
    sudo setfacl -R -m u:pi:rwx /var/log/install.log
    ## Manipulation of Soundcards
    echo "#### Moving USB Soundcard to Position Card:0 ####" | tee -a /var/log/install.log
    sudo chmod 777 /etc/modules
    sudo sh -c 'echo "blacklist snd_bcm2835" > /etc/modprobe.d/raspi-blacklist.conf'
    echo "#### Blacklisting snd_bcm 2835 ####" | tee -a /var/log/install.log
    sudo sed -i 's/options snd-usb/#options snd-usb/g' /lib/modprobe.d/aliases.conf
    echo "#### Disabling HMDI Sound - Not required for this build ####"| tee -a /var/log/install.log
    sudo sed -i 's/dtoverlay=vc4-kms-v3d/dtoverlay=vc4-kms-v3d,noaudio/g' /boot/firmware/config.txt
    sudo cp -f /home/pi/svxlinkbuilder/configs/asound.conf /etc/modprobe.d/asound.conf
    echo "#### Setting up Loopback Soundcard ####" | tee -a /var/log/install.log
    echo snd-aloop > /etc/modules
    sudo cp -f /home/pi/svxlinkbuilder/configs/loopback.conf /etc/asound.conf
    echo "#### Reseting alsa-state.service #### " | tee -a /var/log/install.log
    sudo mkdir /etc/alsa
    sudo touch /etc/alsa/state-daemon.conf
    sudo systemctl restart alsa-state.service
    # installing locales.
 
# Function to install locale if not already available
    sudo cp -f /home/pi/svxlinkbuilder/addons/locale.gen /etc/
    sudo locale-gen

echo "Locale setup completed."


# Set en_GB.UTF-8 as the default locale
sudo localectl set-locale LANG=en_GB.UTF-8

    echo "Locale setup completed."

echo "#### Rebooting after soundcard configuration ####" | tee -a /var/log/install.log

sudo shutdown -r now