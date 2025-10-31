#!/bin/bash
# Go to the log directory
cd /var/log || exit 1
# Timestamps
NOW=$(date +%Y%m%d)
NOW7=$(date -d "7 days ago" +%Y%m%d)
# Backup the current log
cp svxlink.log svxlink."$NOW".txt
# Safely truncate the live log
: > svxlink.log
# Remove backups older than 7 days
rm -f svxlink."$NOW7".txt

