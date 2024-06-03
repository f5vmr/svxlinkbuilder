########!/bin/bash
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

# Function to prompt the user for a new HOSTS URL using whiptail
prompt_for_hosts() {
    while true; do
        new_url=$(whiptail --inputbox "Enter the new URL for HOSTS:" 10 60 "svxportal-uk.ddns.net" 3>&1 1>&2 2>&3)
        exitstatus=$?
        if [ $exitstatus != 0 ]; then
            echo "User canceled the input. Exiting."
            exit 1
        fi
        if [ -z "$new_url" ]; then
            whiptail --msgbox "Please enter a valid URL." 10 60
        else
            break
        fi
    done
    echo "$new_url"
}

# Function to confirm the new HOSTS URL with the user using whiptail
confirm_hosts() {
    whiptail --yesno "Is this URL correct? $1" 10 60
    return $?
}

# Check if the section already exists
if grep -q "\[${section_name}\]" "$svxconf_file"; then
    echo "Section $section_name already exists in $svxconf_file" | tee -a /var/log/install.log
else
    echo "Section $section_name does not exist in $svxconf_file" | tee -a /var/log/install.log
    # Optionally, add the section to the configuration file
    echo "Adding section $section_name to $svxconf_file" | tee -a /var/log/install.log
    
    # Prompt for new HOSTS URL
    while true; do
        new_hosts_url=$(prompt_for_hosts)
        
        # Confirm the new HOSTS URL
        confirm_hosts "$new_hosts_url"
        if [ $? == 0 ]; then
            break
        else
            echo "URL confirmation failed. Please re-enter." | tee -a /var/log/install.log
        fi
    done

    # Add the section and configuration lines to the file
    echo "" >> "$svxconf_file"
    echo "[$section_name]" >> "$svxconf_file"
    echo "TYPE=Reflector" >> "$svxconf_file"
    echo "HOSTS=$new_hosts_url" >> "$svxconf_file"
    echo "FMNET=$new_hosts_url" >> "$svxconf_file"
    # Add the rest of the configuration lines as needed
    echo "HOST_PORT=5300" >> "$svxconf_file"
    echo "CALLSIGN=G4NAB-R" >> "$svxconf_file"
    echo 'AUTH_KEY="NE639NR"' >> "$svxconf_file"
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
