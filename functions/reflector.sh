#!/bin/sh
# so we have two variable in GLOBAL scope $LANG and $CONF
reflector() {

select_reflector() {

    local lang="$1"
    local url="$2"

   REFLECTOR_LIST_URL="https://raw.githubusercontent.com/f5vmr/svxreflector_data/main/reflector_list.json"


    # Fetch JSON
    local json
    json=$(curl -fsSL "$REFLECTOR_LIST_URL") || {
        whiptail --msgbox "Failed to download reflector list." 10 60
        return 1
    }

    # Extract relevant reflectors
    local list
    list=$(jq -r --arg lang "$lang" \
        '.reflectors[]
         | select(.countries[] == $lang)
         | "\(.name)|\(.type)|\(.port)|\(.pwd)"' <<< "$json")

    mapfile -t REFLECTORS <<< "$list"
    local COUNT=${#REFLECTORS[@]}

    if [ "$COUNT" -eq 0 ]; then
        whiptail --msgbox "No reflectors available for language: $lang" 10 60
        return 1
    fi

    # One reflector → yes/no
    if [ "$COUNT" -eq 1 ]; then
        IFS='|' read NAME TYPE PORT PWD <<< "${REFLECTORS[0]}"

        whiptail --yesno \
"Connect to this reflector?

Name: $NAME
Type: $TYPE
Port: $PORT
Password: $PWD" \
        15 60

        if [ $? -eq 0 ]; then
            SELECTED_NAME="$NAME"
            SELECTED_TYPE="$TYPE"
            SELECTED_PORT="$PORT"
            SELECTED_PWD="$PWD"
            return 0
        else
            return 1
        fi
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
}

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

}  # end reflector()
