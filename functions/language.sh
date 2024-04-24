#!/bin/bash
#### WHICH LANGUAGE ####
## lang_options en_GB or fr_FR or en_US or es_ES ##

function set_locale() {
    locale=$1.UTF-8

    sudo localectl set-locale LANG=${locale}


    echo "Locale set to ${locale}"
}


function which_language {
    LANG_OPTION=$(whiptail --title "Language Option" --menu "Select Language" 13 78 5 \
        "1" "English (United Kingdom) en_GB" \
        "2" "Français (France) fr_FR" \
        "3" "English (USA) en_US" \
        "4" "Espagnol (Espagne) - es_ES" \
         3>&1 1>&2 2>&3 )



# Set locale based on user's choice
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
    *)
        echo "Invalid choice"
        ;;
esac
    locale=$(echo "$locale" | cut -d'.' -f1)
    lang=$(echo $LANG | grep -o '^[a-zA-Z]*_[a-zA-Z]*')
    echo "${GREEN} #### Language set to $LANG_OPTION $locale #### ${NORMAL}" | tee -a /var/log/install.log
    
    }




 



