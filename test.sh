#!/bin/bash
# Check if the SA818 device is fitted
if (whiptail --title "SA818 Device Check" --yesno "Do you have an SA818 device fitted as a transceiver in your hotspot? If you do not then select 'No' otherwise select 'Yes'." 10 78); then
    sa818=true
else
    sa818=false
fi

# Output the result for verification
echo "SA818 device fitted: $sa818"
