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
    local value=$1
    whiptail --yesno "Is this value correct? $value" 10 60
    return $?
}

# Function to get the current value of a field from a specific section in the configuration file
get_current_value() {
    local section=$1
    local field_name=$2
    awk -v section="$section" -v field="$field_name" '
    $0 == "[" section "]" { in_section = 1; next }
    in_section && $0 ~ /^\[/ { in_section = 0 }
    in_section && $0 ~ "^" field "=" { print substr($0, index($0, "=") + 1); exit }
    ' "$svxconf_file" | tr -d '"'
}

# Function to update the value of a field in a specific section in the configuration file
update_field_value() {
    local section=$1
    local field_name=$2
    local new_value=$3
    awk -v section="$section" -v field="$field_name" -v new_val="$new_value" '
    $0 == "[" section "]" { in_section = 1; print; next }
    in_section && $0 ~ /^\[/ { in_section = 0 }
    in_section && $0 ~ "^" field "=" { print field "=" new_val; next }
    { print }
    ' "$svxconf_file" > "${svxconf_file}.tmp" && mv "${svxconf_file}.tmp" "$svxconf_file"
}

# Function to prompt for and confirm a value, allowing retries
prompt_and_confirm_value() {
    local field_name=$1
    local current_value=$2
    local new_value
    while true; do
        new_value=$(prompt_for_value "$field_name" "$current_value")
        confirm_value "$new_value"
        if [ $? == 0 ]; then
            break
        fi
    done
    echo "$new_value"
}

# Check if the section already exists
if grep -q "\[${section_name}\]" "$svxconf_file"; then
    echo "Section $section_name already exists in $svxconf_file" | tee -a /var/log/install.log
    
    # Get current values for HOSTS, CALLSIGN, and AUTH_KEY
    current_hosts=$(get_current_value "$section_name" "HOSTS")
    current_callsign=$(get_current_value "$section_name" "CALLSIGN")
    current_auth_key=$(get_current_value "$section_name" "AUTH_KEY")

    # Prompt for new values with confirmation
    new_hosts=$(prompt_and_confirm_value "HOSTS" "$current_hosts")
    new_callsign=$(prompt_and_confirm_value "CALLSIGN" "$current_callsign")
    new_auth_key=$(prompt_and_confirm_value "AUTH_KEY" "$current_auth_key")

    # Update the configuration file with the new values
    update_field_value "$section_name" "HOSTS" "$new_hosts"
    update_field_value "$section_name" "CALLSIGN" "$new_callsign"
    update_field_value "$section_name" "AUTH_KEY" "\"$new_auth_key\""

else
    echo "Section $section_name does not exist in $svxconf_file" | tee -a /var/log/install.log
    # Optionally, add the section to the configuration file
    echo "Adding section $section_name to $svxconf_file" | tee -a /var/log/install.log
    
    # Prompt for new values with confirmation
    new_hosts=$(prompt_and_confirm_value "HOSTS" "svxportal-uk.ddns.net")
    new_callsign=$(prompt_and_confirm_value "CALLSIGN" "G4NAB-R")
    new_auth_key=$(prompt_and_confirm_value "AUTH_KEY" "NE639NR")

    # Add the section and configuration lines to the file
    {
    echo ""
    echo "[$section_name]"
    echo "TYPE=Reflector"
    echo "HOSTS=$new_hosts"
    echo "FMNET=$new_hosts"
    echo "HOST_PORT=5300"
    echo "CALLSIGN=$new_callsign"
    echo "AUTH_KEY=\"$new_auth_key\""
    echo "DEFAULT_LANG=en_GB"
    echo "JITTER_BUFFER_DELAY=0"
    echo "DEFAULT_TG=0"
    echo "MONITOR_TGS=235,2350,23561"
    echo "TG_SELECT_TIMEOUT=360"
    echo "ANNOUNCE_REMOTE_MIN_INTERVAL=300"
    echo "EVENT_HANDLER=/usr/share/svxlink/events.tcl"
    echo "NODE_INFO_FILE=/etc/svxlink/node_info.json"
    echo "MUTE_FIRST_TX_LOC=0"
    echo "MUTE_FIRST_TX_REM=0"
    echo "TMP_MONITOR_TIMEOUT=0"
    } >> "$svxconf_file"
fi
