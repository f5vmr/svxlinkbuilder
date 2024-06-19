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
#echo "Section $section_name already exists in $svxconf_file" | sudo tee -a /var/log/install.log
#
#    else
#    echo "no valid option"
#
#    fi
# #   fi
#!/bin/bash

# Define directories and files
CONF_DIR="/etc/svxlink"
svxfile="svxlink.conf"
svxconf_file="$CONF_DIR/$svxfile"

section_name="ReflectorLogic"

# Check if the section already exists
if grep -q "\[${section_name}\]" "$svxconf_file"; then
    echo "Section $section_name already exists in $svxconf_file"
else
    echo "Section $section_name does not exist in $svxconf_file"
    
    # Prompt for new HOSTS URL
    echo "Enter the new URL for HOSTS:"
    read new_hosts_url
    
    # Confirm the new HOSTS URL
    echo "Is this URL correct? $new_hosts_url (yes/no):"
    read answer
    if [ "$answer" != "yes" ]; then
        echo "URL confirmation failed. Exiting."
        exit 1
    fi

    # Add the section and configuration lines to the file
    {
        echo ""
        echo "[$section_name]"
        echo "TYPE=Reflector"
        echo "HOSTS=$new_hosts_url"
        echo "FMNET=$new_hosts_url"
        echo "HOST_PORT=5300"
        echo "CALLSIGN=G4NAB-R"
        echo 'AUTH_KEY="NE639NR"'
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
