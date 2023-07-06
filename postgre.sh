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

# Function to check if a package is installed
is_package_installed() {
    dpkg -s "$1" &> /dev/null
}

# Function to update package lists
update_package_lists() {
    sudo apt update
}

# Function to install packages
install_packages() {
    sudo apt install "$@" -y
}

# Update package lists
update_package_lists && {
    success_message "Package lists updated successfully."

    # Check if PostgreSQL is already installed
    is_package_installed "postgresql" && success_message "PostgreSQL is already installed." ||
    {
        # Install PostgreSQL and PostgreSQL-contrib
        install_packages "postgresql" "postgresql-contrib" &&
        success_message "PostgreSQL and PostgreSQL-contrib installed successfully." ||
        error_message "Failed to install PostgreSQL and PostgreSQL-contrib."
    }

    # Switch to the postgres user
    sudo -i -u postgres &&
    success_message "Switched to the 'postgres' user." ||
    error_message "Failed to switch to the 'postgres' user."
} || error_message "Failed to update package lists."
