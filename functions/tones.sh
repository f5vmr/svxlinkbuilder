#!/bin/bash
function tones {
if [ "$NODE_OPTION" -eq "3" ] || [ "$NODE_OPTION" -eq "4" ]; then
LOGIC_DIR=/usr/share/svxlink/events.d/local
RepeaterLogic="RepeaterLogicType.tcl"
logicfile="$LOGIC_DIR/$RepeaterLogic"
#    # Code to execute if NODE_OPTION is equal to 3 or 4
#    echo "NODE_OPTION is 3 or 4. Executing code..."
#    # Add your code here


# Define the options for the whiptail menu
# Display the whiptail menu and store the selected option in a variable
selected_option=$(whiptail --title "Select Repeater Sound Option" --menu "Choose a sound option:" 15 78 4 \
    "Bell Tone" "Select this option for Default Bell Tone" \
    "Chime" "Select this option for Mellow Chime " \
    "Pip" "Select this option for Pip Tone" \
    "Silence" "Select this option for No Idle Tone" \
    3>&1 1>&2 2>&3)

# Check if the user canceled or selected an option
if [ $? -eq 0 ]; then
    case "$selected_option" in
        "Bell Tone")
            echo "You selected Bell Tone."
            # Add your code for Bell Tone option here
            ;;
        "Chime")
            echo "You selected Chime."
            sed -i 's/playTone 1100/playTone 1190/g' "$logicfile"
            ;;
        "Pip")
            echo "You selected Pip."
            # Step 1: Comment out playTone lines in repeater_idle {}
            sudo sed -i '/^proc repeater_idle {}/,/^}/ s/^\s*playTone /#&/' "$logicfile"

            # Step 2: Add CW::play "E"; before closing brace in repeater_idle {}
            sudo sed -i '/^proc repeater_idle {}/,/^}/ s/^}/    CW::play "E";\n}/' "$logicfile"
;;       
        "Silence")
            echo "You selected Silence."
            sed -i 's/playTone 1100/\#playTone 1100/g' "$logicfile"
            sed -i 's/playTone 1200/\#playTone 1200/g' "$logicfile"
            ;;
    esac
else
    echo "You cancelled. Tones not changed."
fi
# Repeater Close Sound Option
            selected_option=$(whiptail --title "Repeater Close Sound Option" --menu "Choose a sound option:" 15 78 4 \
    "Default Tone" "Select this option for Default Tone (Bi-Boop)" \
    "No Tone" "Just carrier shut-off" \
    "VA-Barred" "Select this option for CW VA (...-.-) Tone" \
    3>&1 1>&2 2>&3)

if [ $? -eq 0 ]; then
    case "$selected_option" in
        "Default Tone")
            echo "You selected Bell Tone."
            # Add your code for Bell Tone option here
            ;;
        "No Tone")
            echo "You selected carrier shut-off"
            sed -i '89,92d' "$logicfile"
            ;;
        "VA-Barred")
            echo "You selected CW VA-Barred."
            sed -i '89,92c\CW::play "-";' "$logicfile"
            ;;
    esac
else
    echo "User cancelled selection."
fi


# Function to get the current IDLE_TIMEOUT value from svxlink.conf
get_idle_timeout() {
    idle_timeout=$(grep -Po '(?<=^IDLE_TIMEOUT=).*' /etc/svxlink/svxlink.conf)
    echo "$idle_timeout"
}

# Function to update the IDLE_TIMEOUT value in svxlink.conf
update_idle_timeout() {
    sed -i "/^\[RepeaterLogic\]/,/^\[/ s/^IDLE_TIMEOUT=.*/IDLE_TIMEOUT=$1/" /etc/svxlink/svxlink.conf
}


# Get the current IDLE_TIMEOUT value
current_idle_timeout=$(get_idle_timeout)

# Use whiptail to prompt the user for a new IDLE_TIMEOUT value
new_idle_timeout=$(whiptail --title "Change IDLE_TIMEOUT (End of QSO)" --inputbox "Current IDLE_TIMEOUT in secs : $current_idle_timeout\nEnter new IDLE_TIMEOUT:" 10 78 "$current_idle_timeout" 3>&1 1>&2 2>&3)

# Check if the user canceled or entered a new value
if [ $? -eq 0 ]; then
    # Update the IDLE_TIMEOUT value in svxlink.conf
    update_idle_timeout "$new_idle_timeout"
    whiptail --title "Success" --msgbox "IDLE_TIMEOUT updated successfully to $new_idle_timeout." 8 78
else
    whiptail --title "Canceled" --msgbox "No changes were made to IDLE_TIMEOUT." 8 78
fi
#### Add "-" "...-.-" to CW.tcl
CWLogic="CW.tcl"
LOGIC_DIR=/usr/share/svxlink/events.d/local
cwfile="$LOGIC_DIR/$CWLogic"
# Adding the VA Bar code to CW.tcl
sudo sed -i '72a "-" "...-.-"' /usr/share/svxlink/events.d/local/CW.tcl
sed -i 's/playTone 400 900 50/\#playTone 400 900 50/g' "$logicfile"
sed -i 's/playTone 360 900 50/\#playTone 360 900 50/g' "$logicfile"
sed -i 's/\#playTone 360 900 50/CW::play \"\-\"\;/' "$logicfile"

#### End of CW.tcl changes

#### 
else
    # Code to execute if NODE_OPTION is not equal to 3 or 4
    echo "NODE_OPTION is not 3 or 4. Skipping code..."
    # Add optional alternative code here
fi
} 