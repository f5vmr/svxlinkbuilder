#!/bin/bash
CONF_DIR="/etc/svxlink"
LOGIC_DIR="/usr/share/svxlink/events.d/local"
svxfile="svxlink.conf"
logictcl="Logic.tcl"
logicfile="$LOGIC_DIR/$logictcl"
svxconf_file="$CONF_DIR/$svxfile"
##### Adding a ReflectorLogic section to svxlink.conf #####
if [[ "$NODE_OPTION" == "2" ]] || [[ "$NODE_OPTION" == "4" ]]; then 
    section_name="ReflectorLogic"

    # Check if the section already exists

    if grep -q "\[${section_name}\]" "$svxconf_file"; then
echo "Section $section_name already exists in $svxconf_file" | tee -a /var/log/install.log

    else
    echo "no valid option"

    fi
    fi