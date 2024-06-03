##!/bin/bash
#CONF_DIR="/etc/svxlink"
#LOGIC_DIR="/usr/share/svxlink/events.d/local"
#svxfile="svxlink.conf"
#logictcl="Logic.tcl"
#logicfile="$LOGIC_DIR/$logictcl"
#svxconf_file="$CONF_DIR/$svxfile"
###### Adding a ReflectorLogic section to svxlink.conf #####
##if [[ "$NODE_OPTION" == "2" ]] || [[ "$NODE_OPTION" == "4" ]]; then 
#    section_name="ReflectorLogic"
#
#    # Check if the section already exists
#
#    if grep -q "\[${section_name}\]" "$svxconf_file"; then
#echo "Section $section_name already exists in $svxconf_file" | tee -a /var/log/install.log
#
#    else
#    echo "no valid option"
#
#    fi
# #   fi
 #!/bin/bash

# Define directories and files
CONF_DIR="/etc/svxlink"
LOGIC_DIR="/usr/share/svxlink/events.d/local"
svxfile="svxlink.conf"
logictcl="Logic.tcl"
logicfile="$LOGIC_DIR/$logictcl"
svxconf_file="$CONF_DIR/$svxfile"

section_name="ReflectorLogic"

# Function to prompt the user for a new value using whiptail
prompt_for_value() {
    local field_name=$1
    local current_value=$2
    new_value=$(whiptail --inputbox "Enter the new value for $field_name (current value: $current_value):" 10 60 "$current_value" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus != 0 ]; then
        echo "User canceled the input. Exiting."
        exit 1
    fi
    echo "$new_value"
}

# Function to confirm the new value with the user using whiptail
confirm_value() {
    whiptail --yesno "Is this value correct? $1" 10 60
    return $?
}

# Function to get the current value of a field from the configuration file
get_current_value() {
    local field_name=$1
    grep -E "^${field_name}=" "$svxconf_file" | cut -d'=' -f2 | tr -d '"'
}

# Check if the section already exists
if grep -q "\[${section_name}\]" "$svxconf_file"; then
    echo "Section $section_name already exists in $svxconf_file" | tee -a /var/log/install.log
    
    # Get current values for HOSTS, CALLSIGN, and AUTH_KEY
    current_hosts=$(get_current_value "HOSTS")
    current_callsign=$(get_current_value "CALLSIGN")
    current_auth_key=$(get_current_value "AUTH_KEY")

    # Prompt for new values
    new_hosts=$(prompt_for_value "HOSTS" "$current_hosts")
    new_callsign=$(prompt_for_value "CALLSIGN" "$current_callsign")
    new_auth_key=$(prompt_for_value "AUTH_KEY" "$current_auth_key")

    # Confirm the new values
    confirm_value "$new_hosts"
    if [ $? != 0 ]; then
        echo "URL confirmation failed. Exiting."
        exit 1
    fi
    confirm_value "$new_callsign"
    if [ $? != 0 ]; then
        echo "CALLSIGN confirmation failed. Exiting."
        exit 1
    fi
    confirm_value "$new_auth_key"
    if [ $? != 0 ]; then
        echo "AUTH_KEY confirmation failed. Exiting."
        exit 1
    fi

    # Update the configuration file with the new values
    sed -i "s|^HOSTS=.*|HOSTS=$new_hosts|" "$svxconf_file"
    sed -i "s|^CALLSIGN=.*|CALLSIGN=$new_callsign|" "$svxconf_file"
    sed -i "s|^AUTH_KEY=.*|AUTH_KEY=\"$new_auth_key\"|" "$svxconf_file"

else
    echo "Section $section_name does not exist in $svxconf_file" | tee -a /var/log/install.log
    # Optionally, add the section to the configuration file
    echo "Adding section $section_name to $svxconf_file" | tee -a /var/log/install.log
    
    # Prompt for new values
    new_hosts=$(prompt_for_value "HOSTS" "svxportal-uk.ddns.net")
    new_callsign=$(prompt_for_value "CALLSIGN" "G4NAB-R")
    new_auth_key=$(prompt_for_value "AUTH_KEY" "NE639NR")

    # Confirm the new values
    confirm_value "$new_hosts"
    if [ $? != 0 ]; then
        echo "URL confirmation failed. Exiting."
        exit 1
    fi
    confirm_value "$new_callsign"
    if [ $? != 0 ]; then
        echo "CALLSIGN confirmation failed. Exiting."
        exit 1
    fi
    confirm_value "$new_auth_key"
    if [ $? != 0 ]; then
        echo "AUTH_KEY confirmation failed. Exiting."
        exit 1
    fi

    # Add the section and configuration lines to the file
    echo "" >> "$svxconf_file"
    echo "[$section_name]" >> "$svxconf_file"
    echo "TYPE=Reflector" >> "$svxconf_file"
    echo "HOSTS=$new_hosts" >> "$svxconf_file"
    echo "FMNET=$new_hosts" >> "$svxconf_file"
    echo "HOST_PORT=5300" >> "$svxconf_file"
    echo "CALLSIGN=$new_callsign" >> "$svxconf_file"
    echo "AUTH_KEY=\"$new_auth_key\"" >> "$svxconf_file"
    echo "DEFAULT_LANG=en_GB" >> "$svxconf_file"
    echo "JITTER_BUFFER_DELAY=0" >> "$svxconf_file"
    echo "DEFAULT_TG=0" >> "$svxconf_file"
    echo "MONITOR_TGS=235,2350,23561" >> "$svxconf_file"
    echo "TG_SELECT_TIMEOUT=360" >> "$svxconf_file"
    echo "ANNOUNCE_REMOTE_MIN_INTERVAL=300" >> "$svxconf_file"
    echo "EVENT_HANDLER=/usr/share/svxlink/events.tcl" >> "$svxconf_file"
    echo "NODE_INFO_FILE=/etc/svxlink/node_info.json" >> "$svxconf_file"
    echo "MUTE_FIRST_TX_LOC=0" >> "$svxconf_file"
    echo "MUTE_FIRST_TX_REM=0" >> "$svxconf_file"
    echo "TMP_MONITOR_TIMEOUT=0" >> "$svxconf_file"
fi
