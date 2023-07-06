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

# Function to check if a command is available
function command_available {
    if ! command -v $1 &> /dev/null; then
        return 1 # Command not available
    else
        return 0 # Command available
    fi
}

# Check if curl is already installed
if ! command_available curl; then
    success_message "curl is not installed. Installing curl..."
    sudo apt install curl -y

    if [ $? -eq 0 ]; then
        success_message "curl installed successfully."
    else
        error_message "Failed to install curl."
        exit 1
    fi
else
    success_message "curl is already installed."
fi

# Check if pgAdmin is already installed
if ! command_available pgadmin4; then
    # Add pgAdmin GPG key
    sudo curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add

    if [ $? -eq 0 ]; then
        success_message "pgAdmin GPG key added successfully."
    else
        error_message "Failed to add pgAdmin GPG key."
        exit 1
    fi

    # Check if pgAdmin repository is already added
    if ! grep -q "pgadmin4" /etc/apt/sources.list.d/pgadmin4.list; then
        # Add pgAdmin repository to sources.list.d
        sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list'

        if [ $? -eq 0 ]; then
            success_message "pgAdmin repository added successfully."

            # Update package lists and install pgAdmin4
            sudo apt update && sudo apt install pgadmin4 -y

            if [ $? -eq 0 ]; then
                success_message "pgAdmin4 installed successfully."
            else
                error_message "Failed to install pgAdmin4."
            fi
        else
            error_message "Failed to add pgAdmin repository to sources.list.d."
            exit 1
        fi
    else
        success_message "pgAdmin repository is already added."
    fi
else
    success_message "pgAdmin is already installed."
fi
