#!/bin/bash
function tones {
if [ "$NODE_OPTION" -eq "3" ] || [ "$NODE_OPTION" -eq "4" ]; then
LOGIC_DIR=/usr/share/svxlink/events.d/local
RepeaterLogic="RepeaterLogic.tcl"
logicfile="$LOGIC_DIR/$RepeaterLogic"
#    # Code to execute if NODE_OPTION is equal to 3 or 4
#    echo "NODE_OPTION is 3 or 4. Executing code..."
#    # Add your code here


# Define the options for the whiptail menu
# Display the whiptail menu and store the selected option in a variable
selected_option=$(whiptail --title "Sélectionnez l'option du son du répéteur" --menu "Choisir une option de tonalité de relais:" 15 78 4 \
    "Ton de Cloche" "Sélectionnez cette option pour la tonalité de cloche par défaut" \
    "Carillon" "Sélectionnez cette option pour un carillon doux" \
    "Pip" "Sélectionnez cette option pour la tonalité pip" \
    "Silence" "Sélectionnez cette option pour desactiver la tonalité" \
    3>&1 1>&2 2>&3)

# Check if the user canceled or selected an option
if [ $? -eq 0 ]; then
    case "$selected_option" in
        "Bell Tone")
            echo "Vous avez selectionne le son cloche."
            # Add your code for Bell Tone option here
            ;;
        "Chime")
            echo "Vous avez selectionne le son carillon."
            sed -i 's/playTone 1100/playTone 1180/g' "$logicfile"
            ;;
        "Pip")
            echo "Vous avez selectionne le son Pip."
            sed -i 's/playTone 1100/\#playTone 1100/g' "$logicfile"
            sed -i 's/playTone 1200/\#playTone 1200/g' "$logicfile"
            sed -i '/#playTone 1200 \[expr {round(pow(\$base, \$i) \* 150 \/ \$max)}\] 100;/a\with CW::play "E";' "$logicfile"
            ;;
        "Silence")
            echo "Vous avez desavtivé le son."
            sed -i 's/playTone 1100/\#playTone 1100/g' "$logicfile"
            sed -i 's/playTone 1200/\#playTone 1200/g' "$logicfile"
            ;;
    esac
else
    echo "Annulation. PAde de changement de son."
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
new_idle_timeout=$(whiptail --title "Change IDLE_TIMEOUT (End of QSO)" --inputbox "Current IDLE_TIMEOUT in secs : $current_idle_timeout\nEnter new IDLE_TIMEOUT:" 10 60 "$current_idle_timeout" 3>&1 1>&2 2>&3)

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


#### 
else
    # Code to execute if NODE_OPTION is not equal to 3 or 4
    echo "NODE_OPTION n'est pas 3 ou 4. fermeture du programme..."
    # Add optional alternative code here
fi
} 
