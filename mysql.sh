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
else
    error_message "Failed to update package lists."
    exit 1
fi

# Check if MySQL Server is already installed
if dpkg -s mysql-server &> /dev/null; then
    success_message "MySQL Server is already installed."
else
    # Install MySQL Server
    sudo apt install mysql-server -y
    if [ $? -eq 0 ]; then
        success_message "MySQL Server installed successfully."
    else
        error_message "Failed to install MySQL Server."
        exit 1
    fi

    # Secure MySQL installation
    sudo mysql_secure_installation
    if [ $? -eq 0 ]; then
        success_message "MySQL installation secured successfully."
    else
        error_message "Failed to secure MySQL installation."
        exit 1
    fi
fi

# Prompt user to create a new user
read -p "Do you want to create a new MySQL user with all privileges? (yes/no): " create_user

# Check user's response
if [[ "$create_user" == "yes" ]]; then
    # Prompt user to enter username
    read -p "Enter username for the new MySQL user: " username

    # Prompt user to enter password
    read -s -p "Enter password for the new MySQL user: " password

    # Log in to MySQL as root
    sudo mysql -u root -p <<EOF
    CREATE USER IF NOT EXISTS '${username}'@'localhost' IDENTIFIED BY '${password}';
    GRANT ALL PRIVILEGES ON *.* TO '${username}'@'localhost' WITH GRANT OPTION;
    FLUSH PRIVILEGES;
    EXIT
EOF
    if [ $? -eq 0 ]; then
        success_message "New user created with all privileges."
    else
        error_message "Failed to create new user with all privileges."
        exit 1
    fi
else
    success_message "Skipping new user creation."
fi
