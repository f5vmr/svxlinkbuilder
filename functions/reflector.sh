#!/bin/sh
function reflector() {
# we need to get the $lang variable from the main install script
function select_reflector() {
configure_lang =${lang}
# now we get from the github repository the reflector list based on the language
REFLECTOR_LIST_URL="https://raw.githubusercontent.com/f5vmr/reflector_list.json"
# now we can present the user with a whiptail menu to select the reflector

    local lang="$1"
    local url="$2"
    # Fetch JSON
    local json
    json=$(curl -fsSL "$url") || {
        whiptail --msgbox "Failed to download reflector list." 10 60
        return 1
    }

    # Extract matching reflectors: name|type|port|pwd
    local list
    list=$(jq -r --arg lang "$lang" \
        '.reflectors[]
         | select(.countries[] == $lang)
         | "\(.name)|\(.type)|\(.port)|\(.pwd)"' <<< "$json")

    # Load lines into array
    local REFLECTORS
    mapfile -t REFLECTORS <<< "$list"
    local COUNT=${#REFLECTORS[@]}

    if (( COUNT == 0 )); then
        whiptail --msgbox "No reflectors available for language: $lang" 10 60
        return 1
    fi

    # SINGLE REFLECTOR → YES/NO
    if (( COUNT == 1 )); then
        IFS='|' read NAME TYPE PORT PWD <<< "${REFLECTORS[0]}"

        whiptail --yesno \
"Connect to this reflector?

Name: $NAME
Type: $TYPE
Port: $PORT
Password: $PWD" \
        15 60

        if [[ $? -eq 0 ]]; then
            # Export selected variables
            SELECTED_NAME="$NAME"
            SELECTED_TYPE="$TYPE"
            SELECTED_PORT="$PORT"
            SELECTED_PWD="$PWD"
            return 0
        else
            return 1
        fi
    fi

    # MULTIPLE REFLECTORS → MENU
    local MENU_ITEMS=()
    for ITEM in "${REFLECTORS[@]}"; do
        IFS='|' read NAME TYPE PORT PWD <<< "$ITEM"
        MENU_ITEMS+=("$NAME" "$TYPE / Port:$PORT")
    done

    local choice
    choice=$(whiptail --menu "Choose a reflector" 20 70 10 \
              "${MENU_ITEMS[@]}" \
              3>&1 1>&2 2>&3)

    [[ -z "$choice" ]] && return 1

    # Look up chosen reflector to return full details
    for ITEM in "${REFLECTORS[@]}"; do
        IFS='|' read NAME TYPE PORT PWD <<< "$ITEM"
        if [[ "$NAME" == "$choice" ]]; then
            SELECTED_NAME="$NAME"
            SELECTED_TYPE="$TYPE"
            SELECTED_PORT="$PORT"
            SELECTED_PWD="$PWD"
            return 0
        fi
    done

    return 1
} 
#TYPE is particularly relevant. A type 1 has a passwd that is known
# so if type 1 we can prefill CALLSIGN = $CALL abd 
# so we advise the user of the state of his entry to the reflector
if $TYPE -eq "1" 
then
    whiptail --msgbox "You have selected a Type 1 reflector. The password is known and will be prefilled. You can proceed to register with the reflector on completion." 10 60
    sed -i "s|^AUTH_KEY=.*|AUTH_KEY=\"$PWD\"|" "$CONF"

elif $TYPE -eq "2"
#parse the [ReflectorLogic] section of svxlink.conf to replace #AUTH_KEY="Change this key now" with AUTH_KEY=$PWD


then
    whiptail --msgbox "You have selected a Type 2 reflector. You will need to contact the reflector sysop to obtain a password before you can register A password 'password' has been entered" 10 60
sed -i 's|^AUTH_KEY=.*|AUTH_KEY="password"|' "$CONF"
elif $TYPE -eq "3"
then
    whiptail --msgbox "You have selected a Type 3 reflector. No password is required. Your registration will be automatically submitted." 10 60
    sed -i '/^\[ReflectorLogic\]/,/^\[/{ s|^TYPE=ReflectorV2|TYPE=Reflector| }' "$CONF"
    sed -i '/^\[ReflectorLogic\]/,/^\[/{ s|^#|| }' "$CONF"
    sed -i '/^\[ReflectorLogic\]/,/^\[/{ s|^AUTH_KEY=|#AUTH_KEY=| }' "$CONF"
# here we ask the questions. then we can use sed to replace the relevant lines in the [ReflectorLogic] section
# these are the variables we need to set CERT_GIVEN="$user_given"
#CERT_SUR="$user_surname"
whiptail --inputbox "Enter your Given Name:" 10 60 3>&1 1>&2 2>&3
CERT_GIVEN=$?
whiptail --inputbox "Enter your Surname:" 10 60 3>&1 1>&2 2>&3
CERT_SUR=$?
whiptail --inputbox "Enter your Organizational Unit Name:Repeater?" 10 60 3>&1 1>&2 2>&3
CERT_OU=$?
whiptail --inputbox "Enter your Organization Name:Club?" 10 60 3>&1 1>&2 2>&3
CERT_ORG=$?
whiptail --inputbox "Enter your Locality Name:Town?" 10 60 3>&1 1>&2 2>&3
CERT_LOC=$?
whiptail --inputbox "Enter your State or Province Name:County?" 10 60 3>&1 1>&2 2>&3
CERT_STATE=$?
whiptail --inputbox "Enter your Country Name (2 letter code):GB?" 10 60 3>&1 1>&2 2>&3
CERT_COUNTRY=$?
## SED commands to replace the relevant lines in the [ReflectorLogic] section
sed -i '/^\[ReflectorLogic\]/,/^\[/{ s|^CERT_SUBJ_givenName=.*|CERT_SUBJ_givenName='"$CERT_GIVEN"'| }' "$CONF"
sed -i '/^\[ReflectorLogic\]/,/^\[/{ s|^CERT_SUBJ_surname=.*|CERT_SUBJ_surname='"$CERT_SUR"'| }' "$CONF"
sed -i '/^\[ReflectorLogic\]/,/^\[/{ s|^CERT_SUBJ_organizationalUnitName=.*|CERT_SUBJ_organizationalUnitName='"$CERT_OU"'| }' "$CONF"
sed -i '/^\[ReflectorLogic\]/,/^\[/{ s|^CERT_SUBJ_organizationName=.*|CERT_SUBJ_organizationName='"$CERT_ORG"'| }' "$CONF"
sed -i '/^\[ReflectorLogic\]/,/^\[/{ s|^CERT_SUBJ_localityName=.*|CERT_SUBJ_localityName='"$CERT_LOC"'| }' "$CONF"
sed -i '/^\[ReflectorLogic\]/,/^\[/{ s|^CERT_SUBJ_stateOrProvinceName=.*|CERT_SUBJ_stateOrProvinceName='"$CERT_STATE"'| }' "$CONF"
sed -i '/^\[ReflectorLogic\]/,/^\[/{ s|^CERT_SUBJ_countryName=.*|CERT_SUBJ_countryName='"$CERT_COUNTRY"'| }' "$CONF"

else
    whiptail --msgbox "Unknown reflector type selected." 10 60
fi

}
