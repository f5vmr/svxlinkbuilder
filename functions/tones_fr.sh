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
selected_option=$(whiptail --title "Sélectionnez l'option du son du répéteur" --menu "Choisir une option de tonalité de relais:" 15 78 4 \
    "Ton de Cloche" "Sélectionnez cette option pour la tonalité de cloche par défaut" \
    "Carillon" "Sélectionnez cette option pour un carillon doux" \
    "Pip" "Sélectionnez cette option pour la tonalité pip" \
    "Silence" "Sélectionnez cette option pour desactiver la tonalité" \
    3>&1 1>&2 2>&3)

# Check if the user canceled or selected an option
if [ $? -eq 0 ]; then
    case "$selected_option" in
        "Tone de Cloche")
            echo "Vous avez selectionne le son cloche."
            # Add your code for Bell Tone option here
            ;;
        "Carillon")
            echo "Vous avez selectionne le son carillon."
            sed -i 's/playTone 1100/playTone 1190/g' "$logicfile"
            ;;
        "Pip")
            echo "You selected Pip."
            sudo sed -i '/^proc repeater_idle {/,/^}/ {s/^\(\s*playTone.*\)$/#\1/}' "$logicfile"
            sudo sed -i '/^proc repeater_idle {/,/^}/ {/^\}/i\  set iterations 0; set base 0;  CW::play "E";}' "$logicfile"
            ;;   
        "Silence")
            echo "Vous avez desactivé le son."
            sed -i 's/playTone 1100/\#playTone 1100/g' "$logicfile"
            sed -i 's/playTone 1200/\#playTone 1200/g' "$logicfile"
            ;;
    esac
else
    echo "Annulation. Pas de de changement de son."
fi

# Repeater Close Sound Option
            selected_option=$(whiptail --title "Repeater Close Option de son" --menu "Choose a sound option:" 15 78 4 \
    "Ton de defaut" "Selecté cette option for Ton de Defaut (Bi-Boop)" \
    "Pas de Ton" "Fermeture sans ton" \
    "VA-Barré" "Selectionné pour CW VA (...-.-) Ton" \
    3>&1 1>&2 2>&3)

if [ $? -eq 0 ]; then
    case "$selected_option" in
        "Ton de defaut")
            echo "Ton de defaut selectionné."
            # Add your code for Bell Tone option here
            ;;
        "Pas de Ton")
            echo "Fermeture sans ton selectionné."
            sed -i '89,92d' "$logicfile"
            ;;
        "VA-Barré")
            echo "VA-Barré selectionné."
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
    echo "NODE_OPTION n'est pas 3 ou 4. fermeture du programme..."
    # Add optional alternative code here
fi
} 
