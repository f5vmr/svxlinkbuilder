#!/bin/bash
# Reflector selection script using global $lang and $CONF

#-------------------------------
# lang_to_regions function
#-------------------------------
lang_to_regions() {
    local input="${1:-$lang}"
    local lang_code="${input%_*}"
    local country="${input#*_}"

    case "$lang_code" in
        en) echo "GB US IE ZA AU NZ CA-EN" ;;
        ie) echo "GB IE" ;;  # GB first
        fr) echo "FR CA-FR CH" ;;
        it) echo "IT CH" ;;
        pt) echo "PT BR" ;;
        es) echo "ES MX AR" ;;
        us) echo "US CA MX" ;;
        *)  echo "$country" ;;
    esac
}
#-------------------------------
# select_reflector function
#-------------------------------
select_reflector() {
    local PRIMARY_REGION
    PRIMARY_REGION=$(lang_to_regions | awk '{print $1}')

    local REFLECTOR_LIST_URL="https://raw.githubusercontent.com/f5vmr/svxreflector_data/main/reflector_list.json"

    # download JSON list
    local json
    if ! json=$(curl -fsSL "$REFLECTOR_LIST_URL"); then
        whiptail --msgbox "Unable to fetch reflector list from server." 10 60
        return 1
    fi

    # extract matching reflectors
    local list
    list=$(jq -r --arg lang "$lang" --arg region "$PRIMARY_REGION" '
        .reflectors[]
        | select(.Language == $lang)
        | select(.countries[] == $region)
        | "\(.name)|\(.type)|\(.port)|\(.pwd)"
    ' <<< "$json")
    echo "DEBUG: lang='$lang'" >&2
    echo "DEBUG: PRIMARY_REGION='$PRIMARY_REGION'" >&2
    echo "DEBUG: jq output:" >&2
printf "%s\n" "$list" >&2

    list=$(echo "$list" | sed '/^[[:space:]]*$/d')


    mapfile -t REFLECTORS <<< "$list"
    local COUNT="${#REFLECTORS[@]}"
    echo "DEBUG: Found $COUNT matching reflectors" >&2

    if [[ "$COUNT" -eq 0 ]]; then
        whiptail --msgbox "No reflectors match: Language=$lang, Region=$PRIMARY_REGION" 10 65
        return 1
    fi

    # auto-select if only one option
    if [[ "$COUNT" -eq 1 ]]; then
        IFS='|' read -r REF_NAME REF_TYPE REF_PORT REF_PWD <<< "${REFLECTORS[0]}"
        [[ "$REF_PWD" == "Null" ]] && REF_PWD=""
        return 0
    fi

    # build whiptail menu
    local menu=()
    for i in "${!REFLECTORS[@]}"; do
        IFS='|' read -r NAME TYPE PORT PWD <<< "${REFLECTORS[$i]}"
        menu+=("$i" "$NAME (Port: $PORT)")
    done

    local choice
    choice=$(whiptail \
        --title "Select Reflector" \
        --menu "Available reflectors for region $PRIMARY_REGION:" \
        20 70 10 \
        "${menu[@]}" \
        3>&1 1>&2 2>&3
    ) || return 1

    IFS='|' read -r REF_NAME REF_TYPE REF_PORT REF_PWD <<< "${REFLECTORS[$choice]}"
    [[ "$REF_PWD" == "Null" ]] && REF_PWD=""
}


#-------------------------------
# reflector mode
#-------------------------------
reflector() {

    whiptail --msgbox \
        "Reflector mode selected.\n\nYou will now choose a reflector." \
        12 60

    select_reflector || return 1

exit

    whiptail --yesno \
"Connect to this reflector?

Name: $REF_NAME
Type: $REF_TYPE
Port: $REF_PORT
Password: ${REF_PWD:-<none>}" \
    15 60 || return 1

    TYPE="$REF_TYPE"
    PWD="$REF_PWD"

    case "$TYPE" in
        1)
            whiptail --msgbox "Type 1 reflector (password supplied)." 10 60
            sed -i "s|^AUTH_KEY=.*|AUTH_KEY=\"$PWD\"|" "$CONF"
            ;;
        2)
            whiptail --msgbox "Type 2 reflector (sysop-provided password required)." 10 60
            sed -i 's|^AUTH_KEY=.*|AUTH_KEY="password"|' "$CONF"
            ;;
        3)
            whiptail --msgbox "Type 3 reflector (no password required)." 10 60
            ;;
        *)
            whiptail --msgbox "Unknown reflector type." 10 60
            ;;
    esac

    # enable reflector logic block
    sed -i '/^\[ReflectorLogic\]/,/^\[/{ 
        s|^TYPE=.*|TYPE=Reflector|
        s|^#AUTH_KEY=|AUTH_KEY=|
    }' "$CONF"

    # certificate fields
    local fields=("Given Name" "Surname" "Organizational Unit / Repeater" \
                  "Organization Name / Group" "Locality" "State / Province" \
                  "2-Letter Country Code")

    local values=()
    for f in "${fields[@]}"; do
        values+=("$(whiptail --inputbox "$f:" 10 60 3>&1 1>&2 2>&3)")
    done

    sed -i '/^\[ReflectorLogic\]/,/^\[/{ 
        s|^CERT_SUBJ_givenName=.*|CERT_SUBJ_givenName='"${values[0]}"'|
        s|^CERT_SUBJ_surname=.*|CERT_SUBJ_surname='"${values[1]}"'|
        s|^CERT_SUBJ_organizationalUnitName=.*|CERT_SUBJ_organizationalUnitName='"${values[2]}"'|
        s|^CERT_SUBJ_organizationName=.*|CERT_SUBJ_organizationName='"${values[3]}"'|
        s|^CERT_SUBJ_localityName=.*|CERT_SUBJ_localityName='"${values[4]}"'|
        s|^CERT_SUBJ_stateOrProvinceName=.*|CERT_SUBJ_stateOrProvinceName='"${values[5]}"'|
        s|^CERT_SUBJ_countryName=.*|CERT_SUBJ_countryName='"${values[6]}"'|
    }' "$CONF"
}


  # end reflector()
