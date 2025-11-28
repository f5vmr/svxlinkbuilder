#!/bin/bash
function initialise {
HOME=/home/pi
CONF_DIR=/etc/svxlink
LOG_DIR=/var/log/
PID_DIR=/var/run/
WWW_PATH=/var/www/
GUI_IDENTIFIER="SVXlink"
SVXLINK_VER="25.05"
SOUNDS_DIR=/usr/share/svxlink/sounds/
username=$USER
logname=$(whoami)
RED='\033[0;31m' # error
GREEN='\033[0;32m' # success
YELLOW='\033[0;33m' # warning
BLUE='\033[0;34m' # info
MAGENTA='\033[0;35m' # question
CYAN='\033[0;36m' # input
WHITE='\033[0;37m' # normal
NORMAL='\033[0m' # normal
locale=""
lang=""
## Create svxlink-node.service if it doesn't exist
SERVICE_FILE="/etc/systemd/system/svxlink-node.service"
if [ ! -f "$SERVICE_FILE" ]; then
    show_info "Creating svxlink-node.service..."
    sudo tee "$SERVICE_FILE" > /dev/null <<EOL
[Unit]
Description=SVXLink Node.js Server
After=network.target

[Service]
# Send logs directly to journald instead of syslog or files
StandardOutput=journal
StandardError=journal

# Ensure service restarts even after journal restarts or SIGHUPs
Restart=always
RestartSec=5

# Allow clean reloads (optional, useful if you add reload scripts later)
ExecReload=/bin/kill -HUP $MAINPID

# Give the process a few seconds to shut down gracefully
TimeoutStopSec=10
Type=simple
User=svxlink
Group=svxlink
ExecStart=/usr/bin/node /var/www/html/scripts/server.js
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
EOL

    show_info "Reloading systemd, enabling, and starting svxlink-node.service..."
    sudo systemctl daemon-reload
    sudo systemctl enable --now svxlink-node.service
    sudo systemctl start svxlink-node.service
else
    show_info "svxlink-node.service already exists."
    # Optional: restart it to ensure it's running
    sudo systemctl restart svxlink-node.service
fi
## Log initialisation
echo -e "$(date)" "${BLUE} #### Commencing initialisation #### ${NORMAL}" | sudo tee -a /var/log/install.log > /dev/null
export HOME
}