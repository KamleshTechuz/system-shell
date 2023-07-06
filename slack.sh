#!/bin/bash

# Color codes
SUCCESS='\033[0;32m'
ERROR='\033[0;31m'
NC='\033[0m' # No color

# Function to display success message
success_message() {
    echo -e "${SUCCESS}$1${NC}"
}

# Function to display error message and exit
error_message() {
    echo -e "${ERROR}$1${NC}"
    exit 1
}

# Check if Slack is already installed
if snap info slack &> /dev/null; then
    success_message "Slack is already installed."
else
    # Update package lists and upgrade packages
    sudo apt update && sudo apt upgrade -y || error_message "Failed to update and upgrade packages."
    success_message "Package lists updated and packages upgraded successfully."

    # Check if snapd is already installed
    if command -v snap &> /dev/null; then
        success_message "snapd is already installed."
    else
        # Install snapd
        sudo apt install snapd -y || error_message "Failed to install snapd."
        success_message "snapd installed successfully."
    fi

    # Check if core snap is already installed
    if snap info core &> /dev/null; then
        success_message "core snap is already installed."
    else
        # Install core snap
        sudo snap install core || error_message "Failed to install core snap."
        success_message "core snap installed successfully."
    fi

    # Install slack snap
    sudo snap install slack || error_message "Failed to install slack snap."
    success_message "slack snap installed successfully."
fi
