#!/bin/bash
# Reflector selection script using global $lang and $CONF

#-------------------------------
# lang_to_regions function
#-------------------------------
lang_to_regions() {
    local input="${1:-$lang}"          # default to global $lang
    local lang_code="${input%_*}"
    local country="${input#*_}"
    local regions

    case "$lang_code" in
        en) regions="US GB IE ZA AU NZ CA-EN" ;;
        fr) regions="FR CA-FR CH" ;;
        it) regions="IT CH" ;;
        pt) regions="PT BR" ;;
        es) regions="ES MX AR" ;;
        *)  regions="$country" ;;
    esac

    # Ensure original country appears first if present
    if echo "$regions" | grep -qw "$country"; then
        regions="$country $(echo "$regions" | sed "s/\b$country\b//")"
    fi

    echo "$regions"
}

#-------------------------------
# select_reflector function
#-------------------------------
select_reflector() {
    # Use global lang
    local PRIMARY_REGION
    PRIMARY_REGION=$(echo "$(lang_to_regions)" | awk '{print $1}')

    local REFLECTOR_LIST_URL="https://raw.githubusercontent.com/f5vmr/svxreflector_data/main/reflector_list.json"

    # Fetch JSON list
    local json
    json=$(curl -fsSL "$REFLECTOR_LIST_URL") || {
        whiptail --msgbox "Failed to download reflector list." 10 60
        return 1
    }

    # Filter reflectors by language + primary region
    local list
    list=$(jq -r \
        --arg lang "$lang" \
        --arg region "$PRIMARY_REGION" \
        '.reflectors[]
         | select(.Language==$lang)
         | select(.countries[]==$region)
         | "\(.name)|\(.type)|\(.port)|\(.pwd)"' <<< "$json"
    )

    # Read into array
    mapfile -t REFLECTORS <<< "$list"
    local COUNT=${#REFLECTORS[@]}

    if [ "$COUNT" -eq 0 ]; then
        whiptail --msgbox "No reflectors available for language $lang and region $PRIMARY_REGION" 10 60
        return 1
    fi

    # Auto-select if exactly one reflector
    if [ "$COUNT" -eq 1 ]; then
        IFS='|' read -r REF_NAME REF_TYPE REF_PORT REF_PWD <<< "${REFLECTORS[0]}"
        [ "$REF_PWD" = "Null" ] && REF_PWD=""
        return 0
    fi

    # Multiple reflectors → whiptail menu
    local menu_list=()
    local idx=0
    for line in "${REFLECTORS[@]}"; do
        IFS='|' read -r NAME TYPE PORT PWD <<< "$line"
        menu_list+=("$idx" "$NAME (Port: $PORT)")
        idx=$((idx + 1))
    done

    local choice
    choice=$(whiptail --title "Select Reflector" \
        --menu "Choose a reflector for region $PRIMARY_REGION" 20 70 10 \
        "${menu_list[@]}" \
        3>&1 1>&2 2>&3
    ) || return 1

    IFS='|' read -r REF_NAME REF_TYPE REF_PORT REF_PWD <<< "${REFLECTORS[$choice]}"
    [ "$REF_PWD" = "Null" ] && REF_PWD=""
}

#-------------------------------
# reflector mode
#-------------------------------
reflector() {
    whiptail --msgbox "You have selected Reflector mode. You will now choose a reflector to connect to." 10 60

    select_reflector || return 1

    whiptail --yesno "Connect to this reflector?

Name: $REF_NAME
Type: $REF_TYPE
Port: $REF_PORT
Password: $REF_PWD" 15 60

    if [ $? -ne 0 ]; then
        return 1
    fi

    # Multiple reflectors → menu handled inside select_reflector

    # Apply selections to configuration
    local TYPE="$REF_TYPE"
    local PWD="$REF_PWD"

    if [ "$TYPE" -eq 1 ]; then
        whiptail --msgbox "Type 1 reflector. Password will be prefilled." 10 60
        sed -i "s|^AUTH_KEY=.*|AUTH_KEY=\"$PWD\"|" "$CONF"

    elif [ "$TYPE" -eq 2 ]; then
        whiptail --msgbox "Type 2 reflector. Sysop-provided password required." 10 60
        sed -i 's|^AUTH_KEY=.*|AUTH_KEY="password"|' "$CONF"

    elif [ "$TYPE" -eq 3 ]; then
        whiptail --msgbox "Type 3 reflector. No password required." 10 60
        sed -i '/^\[ReflectorLogic\]/,/^\[/{ s|^TYPE=ReflectorV2|TYPE=Reflector| }' "$CONF"
        sed -i '/^\[ReflectorLogic\]/,/^\[/{ s|^#|| }' "$CONF"
        sed -i '/^\[ReflectorLogic\]/,/^\[/{ s|^AUTH_KEY=|#AUTH_KEY=| }' "$CONF"

        # Ask for certificate fields
        local CERT_GIVEN CERT_SUR CERT_OU CERT_ORG CERT_LOC CERT_STATE CERT_COUNTRY
        CERT_GIVEN=$(whiptail --inputbox "Given Name:" 10 60 3>&1 1>&2 2>&3)
        CERT_SUR=$(whiptail --inputbox "Surname:" 10 60 3>&1 1>&2 2>&3)
        CERT_OU=$(whiptail --inputbox "Organizational Unit or Repeater:" 10 60 3>&1 1>&2 2>&3)
        CERT_ORG=$(whiptail --inputbox "Organization Name or Group:" 10 60 3>&1 1>&2 2>&3)
        CERT_LOC=$(whiptail --inputbox "Locality Name:" 10 60 3>&1 1>&2 2>&3)
        CERT_STATE=$(whiptail --inputbox "State/Province:" 10 60 3>&1 1>&2 2>&3)
        CERT_COUNTRY=$(whiptail --inputbox "2-Letter Country Code:" 10 60 3>&1 1>&2 2>&3)

        sed -i '/^\[ReflectorLogic\]/,/^\[/{ s|^CERT_SUBJ_givenName=.*|CERT_SUBJ_givenName='"$CERT_GIVEN"'| }' "$CONF"
        sed -i '/^\[ReflectorLogic\]/,/^\[/{ s|^CERT_SUBJ_surname=.*|CERT_SUBJ_surname='"$CERT_SUR"'| }' "$CONF"
        sed -i '/^\[ReflectorLogic\]/,/^\[/{ s|^CERT_SUBJ_organizationalUnitName=.*|CERT_SUBJ_organizationalUnitName='"$CERT_OU"'| }' "$CONF"
        sed -i '/^\[ReflectorLogic\]/,/^\[/{ s|^CERT_SUBJ_organizationName=.*|CERT_SUBJ_organizationName='"$CERT_ORG"'| }' "$CONF"
        sed -i '/^\[ReflectorLogic\]/,/^\[/{ s|^CERT_SUBJ_localityName=.*|CERT_SUBJ_localityName='"$CERT_LOC"'| }' "$CONF"
        sed -i '/^\[ReflectorLogic\]/,/^\[/{ s|^CERT_SUBJ_stateOrProvinceName=.*|CERT_SUBJ_stateOrProvinceName='"$CERT_STATE"'| }' "$CONF"
        sed -i '/^\[ReflectorLogic\]/,/^\[/{ s|^CERT_SUBJ_countryName=.*|CERT_SUBJ_countryName='"$CERT_COUNTRY"'| }' "$CONF"

    else
        whiptail --msgbox "Unknown reflector type." 10 60
    fi
}

  # end reflector()
