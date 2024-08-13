#!/bin/bash
#function sa818_test {
if (whiptail --title "SA818 Device Check" --defaultno --yesno "Do you have an SA818 device fitted as a transceiver in your hotspot? If you do not then select 'No' otherwise select 'Yes'." 10 78); then
    sa818=true
else
    sa818=false
fi
band=$(whiptail --title "SA818 Band Check" --radiolist \
"Do you have a VHF or a UHF SA818?" 10 78 2 \
"UHF" "The 430-440 MHz version" ON \
"VHF" "145 MHz Version" OFF 3>&1 1>&2 2>&3)

echo "$band SA818 device fitted: $sa818"
#}