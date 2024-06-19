#!/bin/bash

# Function to display informational messages
show_info() {
    echo "[INFO] $1"
}

# Check if the cleanup.sh script exists
if [ -f "$CLEANUP_SCRIPT" ]; then
    show_info "Script $CLEANUP_SCRIPT already exists. Exiting."
    exit 0
else
    # Create the cleanup.sh script with the specified content
    cat << 'EOF' > "$CLEANUP_SCRIPT"
#!/bin/bash

# Directory to be cleaned
DIR="/var/www/html/backups"

# Check if directory exists
if [ -d "$DIR" ]; then
    # Find and delete files older than 7 days
    find "$DIR" -type f -mtime +7 -exec rm -f {} \;
else
    echo "Directory $DIR does not exist."
fi
EOF

    # Make the cleanup.sh script executable
    sudo chmod +x "$CLEANUP_SCRIPT"
    show_info "Created and made $CLEANUP_SCRIPT executable."
fi

# Check and add the cleanup.sh script to the sudo crontab if not already present
CRON_JOB="01 00 * * * /home/pi/scripts/cleanup.sh"
( sudo crontab -l | grep -q "$CRON_JOB" ) || ( sudo crontab -l; echo "$CRON_JOB" ) | sudo crontab -

# Inform the user that the crontab entry has been added if it was not present
show_info "Ensured that the crontab entry for $CLEANUP_SCRIPT exists."
