#!/bin/bash

# Bash script to check if python is installed, install it if not, startup python simpleHTTPServer on Port 80


#python3 -m http.server

if ! command -v python3 &> /dev/null
then
    echo "python3 could not be found..installing it now"
    echo $(whoami)

    #need to really test this portion out..don't know if it works [to-do]
    sudo apt-get update
    sudo apt-get install python3 

    nohup python3 -m http.server 80

    exit

else 
    echo "Python3 already installed..."
    echo "======STARTING PYTHON SIMPLE HTTP SERVER AT PORT 8000========"
    
    nohup python3 -m http.server 80 
    exit
fi
