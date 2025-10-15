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
selected_option=$(whiptail --title "Seleccione la opción de sonido repetidor" --menu "Elige una opción de sonido:" 15 78 4 \
    "Tono Campana" "Seleccione esta opción para el tono de timbre predeterminado" \
    "Timbre Suave" "Seleccione esta opción para escuchar un timbre suave" \
    "Pip" "Seleccione esta opción para tono pip" \
    "Silencio" "Seleccione esta opción para que no haya tono inactivo" \
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
            sudo sed -i '/^proc repeater_idle {/,/^}/ {s/^\(\s*playTone.*\)$/#\1/}' "$logicfile"
            sudo sed -i '/^proc repeater_idle {/,/^}/ {/^\}/i\  set iterations 0; set base 0;  CW::play "E";}' "$logicfile"
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
            selected_option=$(whiptail --title "Opción de sonido de cierre del repetidor" --menu "Choose a sound option:" 15 78 4 \
    "Tono predeterminado" "Seleccione esta opción para Tono predeterminado (Bi-Boop)" \
    "Sin tono" "Solo apagado del portador" \
    "VA-Unido" "Select this option for CW VA (...-.-) Tone" \
    3>&1 1>&2 2>&3)

if [ $? -eq 0 ]; then
    case "$selected_option" in
        "Tono predeterminado")
            echo "Has seleccionado el valor predeterminado."
            # Add your code for Bell Tone option here
            ;;
        "Sin tono")
            echo "Has seleccionado el apagado del operador"
            sed -i '89,92d' "$logicfile"
            ;;
        "VA-Unido")
            echo "Usted seleccionó CW VA se unió."
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