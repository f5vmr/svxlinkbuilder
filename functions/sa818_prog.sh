#!/bin/bash
function sa818_prog {
#### This is for the additions of the udracard.sh script to the svxlink.conf file
band = (whiptail --title "SA818 Device Check" -- "Do you have an SA818 device fitted as a transceiver in your hotspot? If you do not then select 'No' otherwise select 'Yes'." 10 78); then
    sa818=true
else
    sa818=false
fi
#### Band checking ####


#### Changing Frequency ####
}