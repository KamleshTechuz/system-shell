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

# Update package lists and upgrade packages
sudo apt update

if [ $? -eq 0 ]; then
    success_message "Package lists updated successfully."

    sudo apt upgrade -y

    if [ $? -eq 0 ]; then
        success_message "Packages upgraded successfully."
    else
        error_message "Failed to upgrade packages."
    fi
else
    error_message "Failed to update package lists."
    exit 1
fi

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    sudo apt install python3 -y

    if [ $? -eq 0 ]; then
        success_message "Python 3 installed successfully."
    else
        error_message "Failed to install Python 3."
        exit 1
    fi
else
    success_message "Python 3 is already installed."
fi

# Check if pip is installed
if ! command -v pip3 &> /dev/null; then
    sudo apt install python3-pip -y

    if [ $? -eq 0 ]; then
        success_message "pip installed successfully."
    else
        error_message "Failed to install pip."
        exit 1
    fi
else
    success_message "pip is already installed."
fi

# Upgrade pip
sudo pip3 install --upgrade pip

if [ $? -eq 0 ]; then
    success_message "pip upgraded successfully."
else
    error_message "Failed to upgrade pip."
    exit 1
fi

# Check if virtualenv is installed
if ! command -v virtualenv &> /dev/null; then
    sudo pip3 install virtualenv

    if [ $? -eq 0 ]; then
        success_message "virtualenv installed successfully."
    else
        error_message "Failed to install virtualenv."
        exit 1
    fi
else
    success_message "virtualenv is already installed."
fi

# Prompt user for folder name
folder_name=""
while [ -z "$folder_name" ]; do
    read -p "Enter folder name: " folder_name
    if [ -d "$folder_name" ]; then
        error_message "Folder '$folder_name' already exists. Please enter a different folder name."
        folder_name=""
    fi
done

# Create the specified directory
mkdir "$folder_name"

if [ $? -eq 0 ]; then
    success_message "Created directory '$folder_name' successfully."
else
    error_message "Failed to create directory '$folder_name'."
    exit 1
fi

# Navigate to the specified directory
cd "$folder_name"

# Prompt user for environment name
env_name=""
while [ -z "$env_name" ]; do
    read -p "Enter environment name: " env_name
    if [ -d "$env_name" ]; then
        error_message "Environment '$env_name' already exists. Please enter a different environment name."
        env_name=""
    fi
done

# Check if the virtual environment already exists
# Create a new virtual environment
virtualenv "$env_name"

if [ $? -eq 0 ]; then
    success_message "Created virtual environment '$env_name' successfully."
else
    error_message "Failed to create virtual environment '$env_name'."
    exit 1
fi

# Activate the virtual environment
source "$env_name/bin/activate"

if [ $? -eq 0 ]; then
    success_message "Activated virtual environment '$env_name' successfully."
else
    error_message "Failed to activate virtual environment '$env_name'."
    exit 1
fi

# Install Jupyter
pip install jupyter

if [ $? -eq 0 ]; then
    success_message "Jupyter installed successfully."
else
    error_message "Failed to install Jupyter."
    exit 1
fi
