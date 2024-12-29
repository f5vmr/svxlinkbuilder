#/bin/bash
    cd /
    logname=$(whoami)
    #### INITIALISE ####
    source "${BASH_SOURCE%/*}/functions/initialise.sh"
    initialise
    #### CHECK OS ####
    ## Install file manipulation pkg ##
     apt-get install -y acl
    ## Set /var/log/install.log ##
     touch /var/log/install.log
     chmod 775 /var/log/install.log
     setfacl -R -m u:pi:rwx /var/log/install.log
    
    ## Install repository key and repository ##
    echo -e "${YELLOW}#### Installing repository key #### ${WHITE}" |  tee -a /var/log/install.log
    # curl -O -q https://online-amateur-radio-club-m0ouk.github.io/oarc-packages/hibby.key
     mv svxlinkbuilder/addons/hibby.key /etc/apt/trusted.gpg.d/hibby.asc
    echo -e "${BLUE}#### Installing repository #### ${WHITE}" |  tee -a /var/log/install.log
    echo "deb https://online-amateur-radio-club-m0ouk.github.io/oarc-packages bookworm main" |  tee -a /etc/apt/sources.list
    echo -e "${BLUE}#### Updating apt #### ${WHITE}" |  tee -a /var/log/install.log
     apt update &&  apt upgrade -y
    ## Install svxlink-server  and dependencies ##
    echo -e "${BLUE}#### Installing svxlink-server #### ${WHITE}" |  tee -a /var/log/install.log
     apt install -y curl svxlink-server qtel apache2 apache2-bin apache2-data apache2-utils php8.2 python3-serial sqlite3 libssl-dev php8.2-sqlite3 toilet libgpiod-dev --fix-missing -y
    echo -e "${BLUE}#### Installing locales #### ${WHITE}" |  tee -a /var/log/install.log
    
    ## Must kill the remotetrx.service to avoid a problem later ##
     systemctl stop remotetrx.service
     systemctl disable remotetrx.service
    echo -e "${RED} #### remotetrx.service stopped #### ${NORMAL}" |  tee -a  /var/log/install.log 
    ## installing locales.##
    ## Set en_GB.UTF-8 as the default locale to begin with.##
     localectl set-locale LANG=en_GB.UTF-8
    ./svxlinkbuilder/install.sh