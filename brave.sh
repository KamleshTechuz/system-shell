#!/bin/bash

# Color codes
SUCCESS='\033[0;32m'
ERROR='\033[0;31m'
NC='\033[0m' # No color

# Function to display success message
success_message() {
    echo -e "${SUCCESS}$1${NC}"
}

# Function to display error message
error_message() {
    echo -e "${ERROR}$1${NC}"
}

# Check if Brave Browser is installed, if not install it
command -v brave-browser &> /dev/null
if [ $? -ne 0 ]; then

    # Check if curl is installed, if not install it
    command -v curl &> /dev/null
    if [ $? -ne 0 ]; then
        success_message "curl is not installed. Installing curl..."
        sudo apt install curl -y || { error_message "Failed to install curl."; exit 1; }
    else
        success_message "curl is already installed."
    fi

    success_message "Brave Browser is not installed. Proceeding with installation..."

    # Download the Brave Browser archive keyring
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg || { error_message "Failed to download Brave Browser archive keyring."; exit 1; }

    # Add Brave Browser repository to sources.list.d
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list || { error_message "Failed to add Brave Browser repository."; exit 1; }

    # Update package lists
    sudo apt update || { error_message "Failed to update package lists."; exit 1; }

    # Install Brave Browser
    sudo apt install brave-browser -y || { error_message "Failed to install Brave Browser."; exit 1; }

    success_message "Brave Browser installed successfully."
else
    success_message "Brave Browser is already installed."
fi
