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
selected_option=$(whiptail --title "Seleziona l'opzione audio del ripetitore" --menu "Scegli un'opzione audio:" 15 78 4 \
    "Campanello" "Seleziona questa opzione per il campanello predefinito" \
    "Melodia" "Seleziona questa opzione per una melodia delicata " \
    "Pip" "Seleziona questa opzione per il tono Pip" \
    "Silenzio" "Seleziona questa opzione per nessun tono" \
    3>&1 1>&2 2>&3)

# Check if the user canceled or selected an option
if [ $? -eq 0 ]; then
    case "$selected_option" in
        "Campanello")
            echo "Hai selezionato campanello."
            # Add your code for Bell Tone option here
            ;;
        "Melodia")
            echo "Hai selezionato melodia."
            sed -i 's/playTone 1100/playTone 1190/g' "$logicfile"
            ;;
        "Pip")
            echo "Hai selezionato Pip."
            # Step 1: Comment out playTone lines in repeater_idle {}
            sudo sed -i '/^proc repeater_idle {}/,/^}/ s/^\s*playTone /#&/' "$logicfile"

            # Step 2: Add CW::play "E"; before closing brace in repeater_idle {}
            sudo sed -i '/^proc repeater_idle {}/,/^}/ s/^}/    CW::play "E";\n}/' "$logicfile"
;;       
        "Silenzio")
            echo "Hai selezionato silenzio."
            sed -i 's/playTone 1100/\#playTone 1100/g' "$logicfile"
            sed -i 's/playTone 1200/\#playTone 1200/g' "$logicfile"
            ;;
    esac
else
    echo "Hai annullato l'operazione. I toni non sono stati modificati."
fi
# Repeater Close Sound Option
            selected_option=$(whiptail --title "Seleziona l'opzione audio di chiusura del ripetitore" --menu "Scegli un'opzione audio:" 15 78 4 \
    "Tono predefinito" "Seleziona questa opzione per il tono predefinito (Bi-Boop)" \
    "Nessun tono" "Solo spegnimento portante" \
    "VA-Barred" "Seleziona questa opzione per il tono CW VA (...-.-)" \
    3>&1 1>&2 2>&3)

if [ $? -eq 0 ]; then
    case "$selected_option" in
        "Tono predefinito")
            echo "Hai selezionato il tono predefinito."
            # Add your code for Bell Tone option here
            ;;
        "Nessun tono")
            echo "Hai selezionato lo spegnimento della portante"
            sed -i '89,92d' "$logicfile"
            ;;
        "VA-Barred")
            echo "Hai selezionato CW VA-Barred."
            sed -i '89,92c\CW::play "-";' "$logicfile"
            ;;
    esac
else
    echo "Selezione annullata dall'utente."
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
new_idle_timeout=$(whiptail --title "Modifica IDLE_TIMEOUT (fine del QSO)" --inputbox "Valore attuale di IDLE_TIMEOUT in secondi: $current_idle_timeout\nInserisci un nuovo IDLE_TIMEOUT:" 10 78 "$current_idle_timeout" 3>&1 1>&2 2>&3)

# Check if the user canceled or entered a new value
if [ $? -eq 0 ]; then
    # Update the IDLE_TIMEOUT value in svxlink.conf
    update_idle_timeout "$new_idle_timeout"
    whiptail --title "Operazione riuscita" --msgbox "IDLE_TIMEOUT aggiornato a $new_idle_timeout." 8 78
else
    whiptail --title "Annullato" --msgbox "Non sono state apportate modifiche a IDLE_TIMEOUT." 8 78
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
    # Add optional alternative code here
fi
} 
