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
## Replace default svxlink.service everytime with our modified version
echo -e "$(date)" "${BLUE} #### Replacing svxlink.service with modified version #### ${NORMAL}" | sudo tee -a /var/log/install.log
SERVICE_FILE="/usr/lib/systemd/system/svxlink.service"
if [ -f "$SERVICE_FILE" ]; then
    sudo rm -f "$SERVICE_FILE"
fi
sudo tee "$SERVICE_FILE" > /dev/null <<EOL
[Unit]
Description=SvxLink repeater control software (Universal CM108 / Any Node)
After=network.target sound.target systemd-udev-settle.service
Wants=systemd-udev-settle.service
Documentation=man:svxlink(1) man:svxlink.conf(5)

[Service]
Type=simple

# Environment variables for paths and user
Environment=RUNASUSER=svxlink
Environment=STATEDIR=/var/lib/svxlink
Environment=CFGFILE=/etc/svxlink/svxlink.conf
Environment=LOGFILE=/var/log/svxlink.log
EnvironmentFile=/etc/default/svxlink
UMask=0002

# Ensure log file exists and has correct permissions
ExecStartPre=/bin/bash -c ' \
    if [[ "${LOGFILE}" = /* ]]; then \
        touch "${LOGFILE}"; \
        chmod u+w "${LOGFILE}"; \
        chown ${RUNASUSER}:$(id -gn ${RUNASUSER}) "${LOGFILE}"; \
    fi \
'

# Ensure state directory exists and has correct permissions
ExecStartPre=/bin/bash -c ' \
    mkdir -m0775 -p "${STATEDIR}"; \
    chmod -R u+rwX "${STATEDIR}"; \
    chown -R ${RUNASUSER}:$(id -gn ${RUNASUSER}) "${STATEDIR}"; \
'

# Universal pre-check for any USB audio device
ExecStartPre=/bin/bash -c ' \
    echo "Waiting for audio device..."; \
    for i in {1..10}; do \
        if aplay -l 2>/dev/null | grep -qi "USB Audio"; then exit 0; fi; \
        sleep 1; \
    done; \
    echo "Warning: No USB audio detected; continuing anyway."; \
'

# Main SvxLink execution
ExecStart=/usr/bin/svxlink --logfile=${LOGFILE} --config=${CFGFILE} --runasuser=${RUNASUSER}

# Optional stop/reload commands
ExecStopPost=/usr/bin/svxlink --config=${CFGFILE} --runasuser=${RUNASUSER} --reset
ExecReload=/bin/kill -s HUP $MAINPID

# General service settings
Restart=on-failure
Nice=-10
TimeoutStartSec=90
TimeoutStopSec=10
LimitCORE=infinity
WorkingDirectory=/etc/svxlink

[Install]
WantedBy=multi-user.target
EOL
## Create svxlink-node.service if it doesn't exist
SERVICE_FILE="/etc/systemd/system/svxlink-node.service"
if [ ! -f "$SERVICE_FILE" ]; then
    echo -e "$(date)" "${BLUE} #### Creating svxlink-node service #### ${NORMAL}" | sudo tee -a /var/log/install.log 

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
    echo -e "$(date)" "${BLUE} #### systemd svxlink-node.service #### ${NORMAL}" | sudo tee -a /var/log/install.log 

    sudo systemctl daemon-reload
    sudo systemctl enable --now svxlink-node.service
    sudo systemctl start svxlink-node.service
else
    echo -e "$(date)" "${BLUE} #### svxlink-node.service already exists #### ${NORMAL}" | sudo tee -a /var/log/install.log 

    # Optional: restart it to ensure it's running
    sudo systemctl restart svxlink-node.service
fi
## Log initialisation
echo -e "$(date)" "${BLUE} #### Commencing initialisation #### ${NORMAL}" | sudo tee -a /var/log/install.log 
export HOME
}