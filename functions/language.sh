#!/bin/bash
#### WHICH LANGUAGE ####
## lang_options en_GB or fr_FR or en_US or es_ES or it_IT##


function set_locale() {
    locale=$1.UTF-8
    echo -e "${YELLOW}Setting locale to ${locale} - ${RED} Please Wait ${YELLOW} #### ${NORMAL}" | sudo tee -a  /var/log/install.log
    sudo localectl set-locale LANG=${locale}
    if [ $? -eq 0 ]; then
        export LANG=${locale}
       
    else
        echo "Failed to set locale"
    fi
}

function which_language {
    LANG_OPTION=$(whiptail --title "Language Option" --menu "Select Language" 13 78 7 \
        \
        "1" "English  (United Kingdom)  en_GB" \
        "2" "Français (France)          fr_FR" \
        "3" "English  (USA)             en_US" \
        "4" "Spanish  (Español)         es_ES" \
        "5" "Portuguese (Português)     pt_PT" \
        "6" "Italian  (Italiano)        it_IT" \
        
         3>&1 1>&2 2>&3 )

    case ${LANG_OPTION} in
        1)
            set_locale "en_GB"
            ;;
        2)
            set_locale "fr_FR"
            ;;
        3)
            set_locale "en_US"
            ;;
        4)
            set_locale "es_ES"
            ;;
        5)
            set_locale "pt_PT"
            ;;
        6)    
            set_locale "it_IT"
            ;;
        *)
            echo "Invalid choice"
            ;;
    esac

    # Check if locale was set
    if [ -n "$locale" ]; then
        locale=$(echo "$locale" | cut -d'.' -f1)
        lang=$(echo $LANG | grep -o '^[a-zA-Z]*_[a-zA-Z]*')

        echo "${GREEN} #### Language set to $LANG_OPTION $locale #### ${NORMAL}" | sudo tee -a /var/log/install.log
    fi
}
    



 



