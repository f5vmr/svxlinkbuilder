#!/bin/bash
#### WHICH LANGUAGE ####
## lang_options en_GB or fr_FR or en_US ##

set_locale() {
    locale=$1.UTF-8
if [ $1 != en_GB ]; then
    sudo localectl set-locale LANG=${locale}
else
    echo 
    #already set
fi
    echo "Locale set to ${locale}"
}


function which_language{

# Function to set locale based on user's choice


# Prompt the user for language choice


    LANG_OPTION=$(whiptail --title "Language Option" --menu "Select Language" 10 78 3 \
    '1' 'English - United Kingdom - en_GB' \
    '2' 'French  - France - fr_FR' \
    '3' 'English - USA - en_US' \
     3>&1 1>&2 2>&3)

    # "4" "Spanish (Spain) - es_ES" 

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

    lang=$(echo $LANG | grep -o '^[a-zA-Z]*_[a-zA-Z]*')
    echo "${GREEN} #### Language set to $LANG_OPTION $lang #### ${NORMAL}" | tee -a /var/log/install.log
    }




 



