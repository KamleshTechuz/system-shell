#!/bin/bash

# Color codes
SUCCESS='\033[0;32m'
ERROR='\033[0;31m'
NC='\033[0m' # No color

# Function to display success message
function success_message {
    echo -e "${SUCCESS}$1${NC}"
}

# Function to display error message
function error_message {
    echo -e "${ERROR}$1${NC}"
}

# Update package lists
sudo apt update

if [ $? -eq 0 ]; then
    success_message "Package lists updated successfully."

    # Check if snapd is already installed
    if ! command -v snap &> /dev/null; then
        success_message "snapd is not installed. Installing snapd..."
        sudo apt install snapd

        if [ $? -eq 0 ]; then
            success_message "snapd installed successfully."
        else
            error_message "Failed to install snapd."
            exit 1
        fi
    else
        success_message "snapd is already installed."
    fi

    # Check if Postman is already installed
    if ! snap list | grep -q postman; then
        success_message "Installing Postman..."
        sudo snap install postman

        if [ $? -eq 0 ]; then
            success_message "Postman installed successfully."
        else
            error_message "Failed to install Postman."
        fi
    else
        success_message "Postman is already installed."
    fi
else
    error_message "Failed to update package lists."
fi
