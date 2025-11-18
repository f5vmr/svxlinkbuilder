#!/bin/sh
# so we have two variable in GLOBAL scope $LANG and $CONF


function select_reflector() {
    local lang="$1"        # e.g. en_GB
    local region="$2"      # e.g. GB, EI, CA-EN, etc.
    local url="$3"

    REFLECTOR_LIST_URL="https://raw.githubusercontent.com/f5vmr/svxreflector_data/main/reflector_list.json"

    # Fetch JSON
    local json
    json=$(curl -fsSL "$REFLECTOR_LIST_URL") || {
        whiptail --msgbox "Failed to download reflector list." 10 60
        return 1
    }

    # Extract reflectors matching language + country/region
    local list
    list=$(jq -r \
        --arg lang "$lang" \
        --arg region "$region" \
        '
        .reflectors[]
        | select(.Language == $lang)
        | select(.countries[] == $region)
        | "\(.name)|\(.type)|\(.port)|\(.pwd)"
        ' <<< "$json"
    )
    source "${BASH_SOURCE%/*}/iso_lang.sh"
    source "${BASH_SOURCE%/*}/iso_resolve.sh"
    iso_resolver "$lang"
    mapfile -t REFLECTORS <<< "$list"
    local COUNT=${#REFLECTORS[@]}

    if [ "$COUNT" -eq 0 ]; then
        whiptail --msgbox "No reflectors available for language: $lang and region: $region" 10 60
        return 1
    fi

    # If exactly one reflector, auto-select
    if [ "$COUNT" -eq 1 ]; then
        IFS='|' read NAME TYPE PORT PWD <<< "${REFLECTORS[0]}"

        # Normalise Null → empty
        if [ "$PWD" = "Null" ]; then PWD=""; fi

        export REF_NAME="$NAME"
        export REF_TYPE="$TYPE"
        export REF_PORT="$PORT"
        export REF_PWD="$PWD"
        return 0
    fi

    # Multiple reflectors → build whiptail menu
    local menu_list=()
    local idx=0

    for line in "${REFLECTORS[@]}"; do
        IFS='|' read NAME TYPE PORT PWD <<< "$line"
        menu_list+=("$idx" "$NAME (Port: $PORT)")
        idx=$((idx+1))
    done

    local choice
    choice=$(whiptail --title "Select Reflector" \
        --menu "Choose a reflector for region $region" 20 70 10 \
        "${menu_list[@]}" \
        3>&1 1>&2 2>&3
    ) || return 1

    IFS='|' read NAME TYPE PORT PWD <<< "${REFLECTORS[$choice]}"

    if [ "$PWD" = "Null" ]; then PWD=""; fi

    export REF_NAME="$NAME"
    export REF_TYPE="$TYPE"
    export REF_PORT="$PORT"
    export REF_PWD="$PWD"

    return 0
}

reflector() {
    # our client has selected reflector mode
    whiptail --msgbox "You have selected Reflector mode. You will now choose a reflector to connect to." 10 60

select_reflector

whiptail --yesno \"Connect to this reflector? 15 60

Name: $NAME
Type: $TYPE
Port: $PORT"
Password: $PWD" 

        if [ $? -eq 0 ]; then
            SELECTED_NAME="$NAME"
            SELECTED_TYPE="$TYPE"
            SELECTED_PORT="$PORT"
            SELECTED_PWD="$PWD"
            return 0
        else
            return 1
        fi
    

    # Multiple reflectors → menu
    local MENU_ITEMS=()
    for ITEM in "${REFLECTORS[@]}"; do
        IFS='|' read NAME TYPE PORT PWD <<< "$ITEM"
        MENU_ITEMS+=("$NAME" "$TYPE / Port:$PORT")
    done

    local choice
    choice=$(whiptail --menu "Choose a reflector" 20 70 10 \
              "${MENU_ITEMS[@]}" \
              3>&1 1>&2 2>&3)

    [ -z "$choice" ] && return 1

    for ITEM in "${REFLECTORS[@]}"; do
        IFS='|' read NAME TYPE PORT PWD <<< "$ITEM"
        if [ "$NAME" = "$choice" ]; then
            SELECTED_NAME="$NAME"
            SELECTED_TYPE="$TYPE"
            SELECTED_PORT="$PORT"
            SELECTED_PWD="$PWD"
            return 0
        fi
    done


###########################################
# AFTER SELECTION — PROCESS TYPE
###########################################

TYPE="$SELECTED_TYPE"
PWD="$SELECTED_PWD"

if [ "$TYPE" -eq 1 ]; then

    whiptail --msgbox "You selected a Type 1 reflector. Password is known and will be prefilled." 10 60
    sed -i "s|^AUTH_KEY=.*|AUTH_KEY=\"$PWD\"|" "$CONF"

elif [ "$TYPE" -eq 2 ]; then

    whiptail --msgbox "Type 2 reflector. Sysop-provided password required. Placeholder entered." 10 60
    sed -i 's|^AUTH_KEY=.*|AUTH_KEY="password"|' "$CONF"

elif [ "$TYPE" -eq 3 ]; then

    whiptail --msgbox "Type 3 reflector. No password required. Auto-registration." 10 60

    sed -i '/^\[ReflectorLogic\]/,/^\[/{ s|^TYPE=ReflectorV2|TYPE=Reflector| }' "$CONF"
    sed -i '/^\[ReflectorLogic\]/,/^\[/{ s|^#|| }' "$CONF"
    sed -i '/^\[ReflectorLogic\]/,/^\[/{ s|^AUTH_KEY=|#AUTH_KEY=| }' "$CONF"

    # Ask for certificate fields
    CERT_GIVEN=$(whiptail --inputbox "Given Name:" 10 60 3>&1 1>&2 2>&3)
    CERT_SUR=$(whiptail --inputbox "Surname:" 10 60 3>&1 1>&2 2>&3)
    CERT_OU=$(whiptail --inputbox "Organizational Unit or Repeater:" 10 60 3>&1 1>&2 2>&3)
    CERT_ORG=$(whiptail --inputbox "Organization Name or Group:" 10 60 3>&1 1>&2 2>&3)
    CERT_LOC=$(whiptail --inputbox "Locality Name :" 10 60 3>&1 1>&2 2>&3)
    CERT_STATE=$(whiptail --inputbox "State/Province :" 10 60 3>&1 1>&2 2>&3)
    CERT_COUNTRY=$(whiptail --inputbox "2-Letter Country Code (eg GB, FR):" 10 60 3>&1 1>&2 2>&3)

    # Apply CERT_* fields
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
