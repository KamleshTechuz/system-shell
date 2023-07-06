#!/bin/sh

#Import the public key used by the package management system
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -

#Create a list file for MongoDB
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

#Reload local package database
sudo apt-get update

#Install the MongoDB packages
sudo apt-get install -y mongodb-org

#Start MongoDB
sudo systemctl start mongod


#echo "deb http://security.ubuntu.com/ubuntu focal-security main" | sudo tee /etc/apt/sources.list.d/focal-security.list

#sudo apt-get update
#sudo apt-get install libssl1.1
