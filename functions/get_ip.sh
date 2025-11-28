#!/bin/bash

function ipaddress {
## Get current IP addresses


# Get the IPv4 address and device (wlan0 or eth0)
ip_address=$(ip -4 route get 1 | grep -oP 'src \K\S+') 
device=$(ip -4 route get 1 | grep -oP 'dev \K\S+') 


## Update /etc/dhcpcd.conf with fixed IP addresses
sudo touch /etc/dhcpcd.conf
sudo chmod 0775 /etc/dhcpcd.conf
sudo sh -c "echo 'interface $device' | sudo tee -a /etc/dhcpcd.conf > /dev/nul"
sudo sh -c "echo 'static ip_address=$ip_address/24' | sudo tee -a /etc/dhcpcd.conf > /dev/nul"

echo -e "$(date)" "${GREEN} Fixed IP address $ip_address with $device updated in /etc/dhcpcd.conf:${NORMAL}" | sudo tee -a /var/log/install.log > /dev/null
}