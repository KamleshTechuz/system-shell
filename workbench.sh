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

# Check if MySQL Workbench is already installed
if dpkg -s mysql-workbench-community &> /dev/null; then
    success_message "MySQL Workbench is already installed."
else
    # Check if MySQL APT configuration file is already installed
    if ! dpkg -s mysql-apt-config &> /dev/null; then
        # Download the MySQL APT configuration file
        wget https://dev.mysql.com/get/mysql-apt-config_0.5.3-1_all.deb && success_message "MySQL APT configuration file downloaded successfully." ||
        { error_message "Failed to download MySQL APT configuration file."; exit 1; }

        # Install the MySQL APT configuration file
        sudo dpkg -i mysql-apt-config_0.5.3-1_all.deb || { error_message "Failed to install MySQL APT configuration file."; exit 1; }

        success_message "MySQL APT configuration file installed successfully."

        # Remove the MySQL APT configuration file
        rm mysql-apt-config_0.5.3-1_all.deb

        success_message "MySQL APT configuration file removed."
    else
        success_message "MySQL APT configuration file is already installed."
    fi

    # Update package lists
    sudo apt-get update && success_message "Package lists updated successfully." || { error_message "Failed to update package lists."; exit 1; }

    # Install MySQL Workbench
    sudo apt-get install mysql-workbench-community -y && success_message "MySQL Workbench installed successfully." ||
    { error_message "Failed to install MySQL Workbench."; exit 1; }
fi
