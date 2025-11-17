#!/bin/sh
## Choice of svxlink reflector based on country
# In this case we are
# we need to get the $lang variable from the main install script
configure_lang =${lang}
# now we get from the github repository the reflector list based on the language
REFLECTOR_LIST_URL="https://raw.githubusercontent.com/f5vmr/reflector_list.json"
# now we can present the user with a whiptail menu to select the reflector
select_reflector() {
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
# A type 2 requires the user to obtain a passwd from the reflector sysop
# A type 3 requires no passwd but the user must register with the reflector to obtain his details
# 
# so when the user wishes to register to a reflector we can provide a list based on country
# so the user has accepted he want to connect to a reflector
# we can provide a list based on country based upon the language selected during installation
#define $lang
# get the svxreflector list based on country/language
#case $lang in
#  "en_Fr" or "en_US" for France or USA)
#    echo "ri49.f4ipa.fr:1:5300:517388"
#    echo "north.america.svxlink.net:3:5300:Null"
# the important thin is that this needs to be broken down into a) the URL b) the reflector type c) the port number d) the password
# the URL is fine, but if the type is 1 then the password is required
# if 2 then the password needs to be obtained from the svxreflector sysop
# if 3 then no password is required, but this sets the process for the client to import his information into the [ReflectorLogic]
# for this we need a further script to handle the svxreflector registration
# step 1 get the user to select the reflector from the list
# step 2 get the user to provide his callsign, location, email address
# step 3 generate the registration file
#step 4 upload the registration file to the reflector server done when the svxreflector client restarts
#Let define the reflector function
#In the below code I would prefer that each language had its own reflector list. We need to set up a pull in 
#a json file from a github repository that contains the reflector list based on language
# so while the below code works it is not the desired end state.
# We can improve this later.
# for example if the language used $lang=fr_FR then we can provide a list of French reflectors that include 
#the north.america.svxlink.net reflector for candians and americans using french as their language.
# So the reflector list needs to be based on language and country.
#lets consider the structure of the reflector list file
# Reflector Name : Reflector Type [1or2or3]:PortNumber:PWD
# we can use a json file for this with each line representing a reflector entry
# {
#   "reflectors": [
#     {
#       "name": "UK Svxlink Reflector",
#       "type": 3,
#       "port": 5300,
#       "pwd": "Null",
#       "countries": ["GB", "US", "CA"]
#     },
#     {
#       "name": "France Svxlink Reflector",
#       "type": 1,
#       "port": 5300,
#       "pwd": "517388",
#       "countries": ["FR", "CA", "BE"]
#     }
#   ]
# }
# we can then parse this json file to provide the reflector list based on the selected language/country
# This would require jq to parse the json file
# lets implement a basic version of this now with a sample jq statement with the reference to the json file held at https://github.com/f5vm/reflector_list.json
# REFLECTOR_LIST_URL="https://raw.githubusercontent.com/f5vmr/reflector_list.json"
# REFLECTOR_LIST=$(curl -s $REFLECTOR_LIST_URL | jq -r --arg lang "$lang" '.reflectors[] | select(.countries[] | contains($lang)) | "\(.name) : \(.type) : \(.port) : \(.pwd)"')
# we can then use this REFLECTOR_LIST variable to provide the menu options in the whiptail menu
# alittle guidance needed on the github repository structure for this reflector list json file is required


function reflector {

REFLECTOR_OPTION=$(whiptail --title "Svxlink Reflector Selection" --menu "Please select the Svxlink Reflector you wish to connect to" 20 78 6 \
        "1" "UK Svxlink Reflector - portal.svxlink.uk : 3 : 5300 : Null" \
        "2" "UK Yorkshire Svxlink Reflector - yorkshire.svxlink.uk : 3 : 5310 : Null" \
        "2" "North America Svxlink Reflector - north.america.svxlink.net : 3 : 5300 : Null" \
        "3" "France Svxlink Reflector - ri49.f4ipa.fr : 1 : 5300 : 517388" \
        "4" "Germany Svxlink Reflector - reflector.db0lt.de : 2 : 5300 : Null" 3>&1 1>&2 2>&3)  

if [ "$REFLECTOR_OPTION" -eq "1" ] 
then
    REFLECTOR_URL="portal.svxlink.uk"
    REFLECTOR_TYPE="3"
    REFLECTOR_PORT="5300"
    REFLECTOR_PWD="Null"
    echo -e "${CYAN}You chose UK Svxlink Reflector ${WHITE}" | sudo tee -a /var/log/install.log
elif [ "$REFLECTOR_OPTION" -eq "2" ] 
then
    REFLECTOR_URL="yorkshire.svxlink.uk"
    REFLECTOR_TYPE="3"
    REFLECTOR_PORT="5310"
    REFLECTOR_PWD="Null"
    echo -e "${CYAN}You chose UK Yorkshire Svxlink Reflector ${WHITE}" | sudo tee -a /var/log/install.log
elif [ "$REFLECTOR_OPTION" -eq "3" ] 
then
    REFLECTOR_URL="north.america.svxlink.net"
    REFLECTOR_TYPE="3"
    REFLECTOR_PORT="5300"
    REFLECTOR_PWD="Null"
    echo -e "${CYAN}You chose North America Svxlink Reflector ${WHITE}" | sudo tee -a /var/log/install.log
elif [ "$REFLECTOR_OPTION" -eq "4" ] 
then
    REFLECTOR_URL="ri49.f4ipa.fr"
    REFLECTOR_TYPE="1"
    REFLECTOR_PORT="5300"
    REFLECTOR_PWD="517388"
    echo -e "${CYAN}You chose France Svxlink Reflector ${WHITE}" | sudo tee -a /var/log/install.log
elif [ "$REFLECTOR_OPTION" -eq "5" ] 
then
    REFLECTOR_URL="reflector.db0lt.de"
    REFLECTOR_TYPE="2"
    REFLECTOR_PORT="5300"
    REFLECTOR_PWD="Null"
    echo -e "${CYAN}You chose Germany Svxlink Reflector ${WHITE}" | sudo tee -a /var/log/install.log
else 
    echo -e "${RED}You did not choose anything${WHITE}" | sudo tee -a /var/log/install.log
fi
    echo "${GREEN}Reflector Option ${WHITE} $REFLECTOR_OPTION"
    export REFLECTOR_URL
    export REFLECTOR_TYPE
    export REFLECTOR_PORT
    export REFLECTOR_PWD
}
# Ok for the basic reflector selection we now need to create a registration file
# We shall do that now in this same function
# we need to get the callsign, location and email address from the user so produce a whiptail to ask for this information
# for each stage we need to ask for confirmation in case of mistakes
# we can then produce the registration file based on this information. The restration information needs to be parsed from 
# the [ReflectorLogic] section of svxlink.conf, so we can use sed to replace the relevant lines.
#CERT_PKI_DIR = "/var/lib/svxlink/pki"
#CERT_KEYFILE = /var/lib/svxlink/pki/G4NAB-P.key
#CERT_CSRFILE = /var/lib/svxlink/pki/G4NAB-P.csr
#CERT_CRTFILE = /var/lib/svxlink/pki/G4NAB-P.crt
#CERT_CAFILE = /var/lib/svxlink/pki/ca-bundle.pem
#CERT_DOWNLOAD_CA_BUNDLE = 1
#CERT_SUBJ_givenName = Chris
#CERT_SUBJ_surname = Jackson
#CERT_SUBJ_organizationalUnitName = SvxLinkUK
#CERT_SUBJ_organizationName = GB
#CERT_SUBJ_localityName = Ashington
#CERT_SUBJ_stateOrProvinceName = Northumberland
#CERT_SUBJ_countryName = GB
#CERT_EMAIL=g4nab.ne63@gmail.com
# The first step is to remove any # from the start of the lines in the whole of [ReflectorLogic] section only but ensure 
# that we do not affect any other sections - We must also maintain a # in front of AUTH_KEY line
# We can do this with sed by targeting the section
# Then we can use whiptail for givenName, surname, organizationalUnitName, organizationName, localityName, stateOrProvinceName, countryName, email
# We can then use sed to replace the lines in the [ReflectorLogic] section with the new information
# Finally we need to set CERT_DOWNLOAD_CA_BUNDLE = 1 to ensure that the CA bundle is downloaded
# We can then inform the user that the registration file has been created and will be uploaded when svxlink is restarted
# End of reflector function

