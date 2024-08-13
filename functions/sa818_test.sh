#!/bin/bash
function sa818_test {
if (whiptail --title "SA818 Device Check" --defaultno --yesno "Do you have an SA818 device fitted as a transceiver in your hotspot? If you do not then select 'No' otherwise select 'Yes'." 10 78); then
    sa818=true
else
    sa818=false
fi
band=(whiptail --title "SA818 Band Check" --radiolist \ "Do you have a VHF or a UHF SA818?" 10 78 2 \ "UHF" "The 430-440 version" ON \"VHF" "145 Mhz Version" OFF 3>&1 1>&2 2>&3); then
# Output the result for verification
#case $? in
#    UHF)
#    echo "UHF selected"
#    # band="UHF"
#    ;;
#    VHF)
#    echo "VHF selected"
#    band="VHF"
#esac

echo " $band SA818 device fitted: $sa818 " 
}