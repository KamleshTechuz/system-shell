#!/bin/bash

# Branch name declaration
pull_branch="main" # branch name from which you want to take pull befor push.
push_branch="main" # branch name in which you want to push.

# Prompt for commit message
read -p "Enter commit message: " commit_message

# Define color variables
green='\033[0;32m'
red='\033[0;31m'
reset='\033[0m'

# Function to display error messages in red color
print_error() {
    echo -e "${red}Error: $1${reset}"
}

# Function to display success messages in green color
print_success() {
    echo -e "${green}$1${reset}"
}

# Check if the commit message is empty
if [[ -z "$commit_message" ]]; then
    print_error "Commit message is required."
    exit 1
fi

# Check if Git is installed
if ! command -v git &> /dev/null; then
    print_error "Git is not installed. Please install Git and try again."
    exit 1
fi

# Check if the current directory is a Git repository
if ! git rev-parse --is-inside-work-tree &> /dev/null; then
    print_error "The current directory is not a Git repository."
    exit 1
fi

# Check if there are any changes to commit
if [[ -n $(git status -s) ]]; then
    print_success "Changes detected. Proceeding with commit and push."
else
    print_success "No changes detected. Exiting script."
    exit 0
fi

# Perform git operations
git add .
git commit -m "$commit_message"

if [[ $? -ne 0 ]]; then
    print_error "Failed to commit changes."
    exit 1
fi

print_success "Changes committed successfully."

git pull origin "$pull_branch"

if [[ $? -ne 0 ]]; then
    print_error "Pulling from origin master failed."
    exit 1
fi

print_success "Pull from origin master successful."

git push origin "$push_branch"

if [[ $? -ne 0 ]]; then
    print_error "Pushing to origin $branch failed."
    exit 1
fi

print_success "Push to origin $branch successful."

print_success "Git operations completed successfully."
