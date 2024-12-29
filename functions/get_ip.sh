#!/bin/bash

function ipaddress {
## Get current IP addresses


# Get the IPv4 address and device (wlan0 or eth0)
ip_address=$(ip -4 route get 1 | grep -oP 'src \K\S+') 
device=$(ip -4 route get 1 | grep -oP 'dev \K\S+') 


## Update /etc/dhcpcd.conf with fixed IP addresses
 touch /etc/dhcpcd.conf
 chmod 0775 /etc/dhcpcd.conf
 sh -c "echo 'interface $device' |  tee -a /etc/dhcpcd.conf > /dev/nul"
 sh -c "echo 'static ip_address=$ip_address/24' |  tee -a /etc/dhcpcd.conf > /dev/nul"

echo -e "$(date)" "${GREEN} Fixed IP address $ip_address with $device updated in /etc/dhcpcd.conf:${NORMAL}" |  tee -a /var/log/install.log

}