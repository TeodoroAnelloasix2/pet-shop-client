#!/usr/bin/env bash

##################################
#                                #   
#  Developer: TeodoroAnelloasix2 #
#  Environment: Free tier aws    #
#                                #
##################################

set -euo pipefail

# Variables
db_cert_file="global-bundle.pem"
db_credentials_name="petshop-db-secret-pem"
aws_region_script="us-east-1"
region_replica="eu-central-1"
cred_file="cred.env"
tmpjson="/tmp/cred_rds.json"
replica_region="eu-central-1"
checked=1

# Descriptions
desc="RDS credentials for connection"



set_env(){
    export $(grep -v '^#' "$cred_file" | xargs)
}

create_tmp_json(){
    cat > "$tmpjson" <<EOF
{
  "Username": "$Username",
  "Password": "$Password"
} 
EOF
}

del_json(){
    rm -rf "$tmpjson"
}

check_aws_secret(){
    
    if ! aws secretsmanager describe-secret --secret-id "$db_credentials_name" --region "$aws_region_script" 2>/dev/null >/dev/null;then
        checked=0
    else
        checked=1
    fi
}

delete_previous(){
    aws secretsmanager remove-regions-from-replication \
        --secret-id "$db_credentials_name" \
        --remove-replica-regions "$replica_region" \
        --region "$aws_region_script" || { echo "Failed to delete replica,aborting"; exit 1; }

    aws secretsmanager delete-secret --force-delete-without-recovery \
        --secret-id "$db_credentials_name" \
         --region "$aws_region_script" || { echo "Failed to delete previous,aborting"; exit 1; }
}

create_aws_secret(){
    aws secretsmanager create-secret --name "$db_credentials_name" --region "$aws_region_script" \
        --add-replica-regions Region="$region_replica"  --force-overwrite-replica-secret \
        --secret-string file://"$tmpjson" \
        --description  "$desc" \
        --tags Key=Project,Value=pet-shop Key=Environment,Value=prod Key=Manteiner,Value=TeodoroAnelloasix2 \
        || { echo "Error creating cert db secret,aborting" ; exit 1; }
}

Help()
{
   # Display Help
   echo "Create secret manager to store rds credentials on aws"
   echo
   echo "Syntax: scriptTemplate [-h|f|g]"
   echo "options:"
   echo "h     Print this Help."
   echo "g     Gracefully: check if exists, if it does, end the script"
   echo "f     Force mode: check if exist,if it does, delete the previous resource"
   echo
}

initial_sequence(){
    set_env
    create_tmp_json
    check_aws_secret
}

main(){
    while getopts ":fhg" option; do
        case $option in
            h) Help
               exit 0
               ;;
            f)
               echo "Checking if secrets already exists"
               initial_sequence
               if [ $checked -eq 1 ];then
                    echo "Deleting previous resource"
                    delete_previous
                    sleep 20
                
               fi
               echo "Creating new secrets"
               create_aws_secret
               del_json
               exit 0
               ;;
            g) 
               echo "Checking if secrets already exists"
               initial_sequence
               if [ $checked -eq 0 ];then
                    echo "Creating secrets"
                    create_aws_secret
                    del_json
               fi   
               echo "Secrets already exists,skipping"
               exit 0
               ;;
            \?)
                echo "Invalid option: -$OPTARG" >&2
                echo "Use -h for help." >&2
                exit 1
                ;;
        esac
    done
}

main "$@"