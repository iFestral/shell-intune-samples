#!/bin/bash

############################################################################################
##
## Script to update Intune-portal to the latest version
## 
## VER 1.0
## Feedback: alg.kolesnikov@outlook.com
############################################################################################


# Check if running with root privileges
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with root privileges. Please use sudo or run as root."
    exit 1
fi

# Variables
log_file="/var/log/update_cp.log"

log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a $log_file
}

# Create log files if they don't exist
touch "$log_file"

# Update the package list, capturing any errors
if ! sudo apt update -y >> "$log_file" 2>&1; then
    log "Failed to update package list. Please check the log for details."
    exit 1
fi

# Check if the intune-portal package is upgradable
upgradable=$(apt list --upgradable 2>/dev/null | grep -i intune-portal)

if [[ -n "$upgradable" ]]; then
    log "intune-portal package is upgradable. Upgrading now..."
    if sudo apt upgrade -y intune-portal >> "$log_file" 2>&1; then
        log "Upgrade completed successfully."
    else
        log "Upgrade failed. Please check the log for details."
        exit 1
    fi
else
    log "intune-portal package is already up to date."
    exit 0
fi
