#!/bin/bash
## here we install the dashboard to /var/www


function install_dash {
    ## install the dashboard
    cd /var/www/
    sudo rm -r html
    sudo git clone https://github.com/f5vmr/SVXLink-Dash-V2 html
    ## change ownership of the dashboard
    sudo chown -R svxlink:svxlink html
    ## change permissions of the dashboard
    sudo chmod -R 775 html
    ## change Apache2 permissions
    cd /etc/apache2/
    sed -i 's/APACHE_RUN_USER=www-data/APACHE_RUN_USER=svxlink/g' envvars
    sed -i 's/APACHE_RUN_GROUP=www-data/APACHE_RUN_GROUP=svxlink/g' envvars
    cd /usr/lib/systemd/system/
    sed -i 's/PrivateTmp=true/PrivateTmp=false/g' apache2.service
    ## restart Apache2
    sudo systemctl daemon-reload
    sudo systemctl restart apache2.service
    ## Dashboard Permissions
    # Define the sudoers file, the source file, the script file, and the config file
#!/bin/bash
# This script is used to upgrade the system for the Permissions required for file handling.

# Define the sudoers file, the source file, the script file, and the config file
SUDOERS_FILE="/etc/sudoers.d/svxlink"
SOURCE_FILE="www-data.sudoers"
CONFIG_FILE="/var/www/html/include/config.inc.php"

# Function to display an info message using whiptail
show_info() {
  whiptail --title "Information" --msgbox "$1" 8 78
}


# Prompt for the dashboard username using whiptail
DASHBOARD_USER=$(whiptail --title "Dashboard Username" --inputbox "Please enter your dashboard username:" 8 78 svxlink 3>&1 1>&2 2>&3)

# Check if the user pressed Cancel or entered an empty input
if [ $? -eq 0 ]; then
    echo "User entered username: $DASHBOARD_USER"
else
    echo "User cancelled the username input."
    exit 1
fi

# Prompt for the dashboard password using whiptail
DASHBOARD_PASSWORD=$(whiptail --title "Dashboard Password" --passwordbox "Please enter your dashboard password:" 8 78 3>&1 1>&2 2>&3)

# Check if the user pressed Cancel or entered an empty input
if [ $? -eq 0 ]; then
    echo "User entered password: [hidden]"
else
    echo "User cancelled the password input."
    exit 1
fi

# Continue with further processing
#echo "Username: $DASHBOARD_USER"
# You typically wouldn't echo the password for security reasons

# Update the config file with the provided username and password
if [ -f "$CONFIG_FILE" ]; then
  sed -i "s/define(\"PHP_AUTH_USER\", \".*\");/define(\"PHP_AUTH_USER\", \"$DASHBOARD_USER\");/" "$CONFIG_FILE"
  sed -i "s/define(\"PHP_AUTH_PW\", \".*\");/define(\"PHP_AUTH_PW\", \"$DASHBOARD_PASSWORD\");/" "$CONFIG_FILE"
  show_info "The config file $CONFIG_FILE has been updated with the new username and password."
else
  whiptail --title "Error" --msgbox "Config file $CONFIG_FILE does not exist. Exiting." 8 78
  exit 1
fi

# Check if the source file exists
# Change ownership of all files in /var/www/html 
find /var/www/html -exec sudo chown svxlink:svxlink {} +

# Inform the user that the ownership change was successful
show_info "Ownership of files in /var/www/html has been changed to svxlink:svxlink, except for the script itself."

# New section to create /home/pi/scripts and cleanup.sh
SCRIPT_DIR="/home/pi/scripts"
CLEANUP_SCRIPT="$SCRIPT_DIR/cleanup.sh"

# Check if the script directory exists, if not, create it
if [ ! -d "$SCRIPT_DIR" ]; then
    mkdir -p "$SCRIPT_DIR"
    show_info "Created directory $SCRIPT_DIR"
fi

# Check if the cleanup.sh script exists
if [ -f "$CLEANUP_SCRIPT" ]; then
    show_info "Script $CLEANUP_SCRIPT already exists. Exiting."
    exit 0
else
    # Create the cleanup.sh script with the specified content
    echo "#!/bin/bash

# Directory to be cleaned
DIR=\"/var/www/html/backups\"

# Check if directory exists
if [ -d \"\$DIR\" ]; then
    # Find and delete files older than 7 days
    find \"\$DIR\" -type f -mtime +7 -exec rm -f {} \;
else
    echo \"Directory \$DIR does not exist.\"
fi" > "$CLEANUP_SCRIPT"

    # Make the cleanup.sh script executable
    sudo chmod +x "$CLEANUP_SCRIPT"
    show_info "Created and made $CLEANUP_SCRIPT executable."
fi

# Check and add the cleanup.sh script to the sudo crontab if not already present
CRON_JOB="01 00 * * * /home/pi/scripts/cleanup.sh"
( sudo crontab -l | grep -q "$CRON_JOB" ) || ( sudo crontab -l; echo "$CRON_JOB" ) | sudo crontab -

# Inform the user that the crontab entry has been added if it was not present
show_info "Ensured that the crontab entry for $CLEANUP_SCRIPT exists."


}