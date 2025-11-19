#!/bin/bash
# Reflector selection script using global $lang and $CONF

#-------------------------------
# lang_to_regions function
#-------------------------------
lang_to_regions() {
    local input="${1:-$lang}"
    local lang_code="${input%_*}"
    local country="${input#*_}"

    local map=""
    case "$lang_code" in
        en) map="US GB IE ZA AU NZ CA-EN" ;;
        fr) map="FR CA-FR CH" ;;
        it) map="IT CH" ;;
        pt) map="PT BR" ;;
        es) map="ES MX AR" ;;
        us) map="US CA MX" ;;
        *)  map="$country" ;;
    esac

    # put original country first if present
    if echo "$map" | grep -qw "$country"; then
        echo "$country $(echo "$map" | sed "s/\b$country\b//")"
    else
        echo "$map"
    fi
}


#-------------------------------
# select_reflector function
#-------------------------------
select_reflector() {
    # Debug toggle: set to 1 to enable verbose log lines to stdout
    local DEBUG=0

    # Ensure globals are unset before starting
    unset REF_NAME REF_TYPE REF_PORT REF_PWD
    REFLECTORS=()

    # Determine primary region and also prepare fallback list (all regions for lang)
    local PRIMARY_REGION
    PRIMARY_REGION=$(lang_to_regions | awk '{print $1}')
    local ALL_REGIONS
    ALL_REGIONS=$(lang_to_regions)    # space-separated list

    $DEBUG && echo "DEBUG: lang='$lang' PRIMARY_REGION='$PRIMARY_REGION' ALL_REGIONS='$ALL_REGIONS'"

    local REFLECTOR_LIST_URL="https://raw.githubusercontent.com/f5vmr/svxreflector_data/main/reflector_list.json"
    local json
    if ! json=$(curl -fsSL "$REFLECTOR_LIST_URL"); then
        whiptail --msgbox "Failed to download reflector list." 10 60
        return 1
    fi

    # function to populate REFLECTORS for a given region
    _populate_for_region() {
        local region="$1"
        local list
        list=$(jq -r --arg lang "$lang" --arg region "$region" '
            .reflectors[]
            | select(.Language == $lang)
            | select(.countries[] == $region)
            | "\(.name)|\(.type)|\(.port)|\(.pwd)"
        ' <<< "$json" ) || list=""

        # trim empty lines
        list=$(printf "%s\n" "$list" | sed '/^[[:space:]]*$/d')

        if [ -n "$list" ]; then
            # append entries to REFLECTORS array
            while IFS= read -r line; do
                REFLECTORS+=("$line")
            done <<< "$list"
        fi
    }

    # Try primary region first
    _populate_for_region "$PRIMARY_REGION"

    # If none found for primary, try the other regions in order
    if [ "${#REFLECTORS[@]}" -eq 0 ]; then
        for r in $ALL_REGIONS; do
            [ "$r" = "$PRIMARY_REGION" ] && continue
            _populate_for_region "$r"
            [ "${#REFLECTORS[@]}" -gt 0 ] && break
        done
    fi

    $DEBUG && printf "DEBUG: FOUND %d reflectors\n" "${#REFLECTORS[@]}"
    $DEBUG && for i in "${!REFLECTORS[@]}"; do echo "DEBUG: REFLECTORS[$i]=${REFLECTORS[$i]}"; done

    if [ "${#REFLECTORS[@]}" -eq 0 ]; then
        whiptail --msgbox "No reflectors available for language $lang (regions tried: $ALL_REGIONS)" 10 70
        return 1
    fi

    if [ "${#REFLECTORS[@]}" -eq 1 ]; then
        IFS='|' read -r REF_NAME REF_TYPE REF_PORT REF_PWD <<< "${REFLECTORS[0]}"
        [ "$REF_PWD" = "Null" ] && REF_PWD=""
        $DEBUG && echo "DEBUG: Auto-selected single reflector: $REF_NAME | $REF_TYPE | $REF_PORT | $REF_PWD"
        return 0
    fi

    # Build menu List
    local menu_list=()
    for i in "${!REFLECTORS[@]}"; do
        IFS='|' read -r NAME TYPE PORT PWD <<< "${REFLECTORS[$i]}"
        menu_list+=("$i" "$NAME (Port: $PORT)")
    done

    $DEBUG && printf "DEBUG: menu_list size: %d\n" "${#menu_list[@]}"

    # Show menu and capture choice
    local choice
    choice=$(whiptail --title "Select Reflector" \
        --menu "Choose a reflector for region $PRIMARY_REGION" 20 70 10 \
        "${menu_list[@]}" \
        3>&1 1>&2 2>&3) || {
            $DEBUG && echo "DEBUG: User cancelled menu or dialog failed (whiptail exit)"
            return 1
        }

    # Validate choice is numeric and within array bounds
    if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
        $DEBUG && echo "DEBUG: Non-numeric choice: '$choice'"
        return 1
    fi
    if [ "$choice" -lt 0 ] || [ "$choice" -ge "${#REFLECTORS[@]}" ]; then
        $DEBUG && echo "DEBUG: Choice out of range: $choice"
        return 1
    fi

    IFS='|' read -r REF_NAME REF_TYPE REF_PORT REF_PWD <<< "${REFLECTORS[$choice]}"
    [ "$REF_PWD" = "Null" ] && REF_PWD=""
    $DEBUG && echo "DEBUG: Selected: $REF_NAME | $REF_TYPE | $REF_PORT | $REF_PWD"
    return 0
}


#-------------------------------
# reflector mode
#-------------------------------
reflector() {

    whiptail --msgbox \
        "Reflector mode selected.\n\nYou will now choose a reflector." \
        12 60

    select_reflector || return 1

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
