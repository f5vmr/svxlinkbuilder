#!/bin/bash
#### WHICH LANGUAGE ####
## lang_options en_GB or fr_FR or en_US or es_ES or it_IT##


function set_locale() {
    locale=$1.UTF-8
    echo -e "${YELLOW}Setting locale to ${locale} - ${RED} Please Wait ${YELLOW} #### ${NORMAL}" | tee -a  /var/log/install.log
    sudo localectl set-locale LANG=${locale}
    if [ $? -eq 0 ]; then
        export LANG=${locale}
       
    else
        echo "Failed to set locale"
    fi
}

function which_language {
    echo "Debugging Language Selection Menu"
    MENU_TEXT="                     Select your preferred language:\n\n"


    LANG_OPTION=$(whiptail --title "Language Option" \
        --menu "$MENU_TEXT" 15 60 6 \
        "1" "English    (United Kingdom)       en_GB" \
        "2" "Français   (France/Canada)        fr_FR" \
        "3" "Français   (Canada)               fr_CA" \
        "4" "Spanish    (Español/Latin.Am)     es_ES" \
        "5" "Portuguese (Português/Brasiliero) pt_PT" \
        "6" "Italian    (Italiano)             it_IT" \
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

    fi
    echo "Exit debugging"
}
    



 



