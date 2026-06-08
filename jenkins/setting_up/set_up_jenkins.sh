#!/usr/bin/env bash

##################################
#                                #   
#  Developer: TeodoroAnelloasix2 #
#  Environment: Free tier aws    #
#                                #
##################################

set -euo pipefail

# Variables
compose_file="docker-compose.yaml"


# Functions



set_cred_hash(){
    
    echo "Settings credentials for traefik dashboard"

    echo "Exporting vars: username,password"
    export $(grep -v '^#' .cred.env | xargs)
    cred_hash=$(htpasswd -nb $username $passwd)
    # Escape $ character 
    cred_hash_escaped=$(echo "$cred_hash" | sed 's/\$/$$/g')
    sed -i "s|<PASTE_HASH_HERE>|${cred_hash_escaped}|g" "$compose_file" || { echo "Failed to set credentials"; exit 1; }
    echo "Credentials injected successfully"
}

start_infra(){
    echo "starting infraestructure"
    docker compose up -d || { echo "Failed to start infra, aborting"; exit 1; }
    echo "Applications ready to use"
}

main(){
    set_cred_hash
    start_infra
}

main