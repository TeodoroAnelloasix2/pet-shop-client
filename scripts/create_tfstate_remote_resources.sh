#!/usr/bin/env bash

##################################
#                                #   
#  Developer: TeodoroAnelloasix2 #
#  Environment: Free tier aws    #
#                                #
##################################

set -euo pipefail

# Variables

aws_region_script="us-east-1"
bkt_name="tfstate-remote-bkt-petshop"
dynDB_name="is-tfstate-locked"
billing_mode_DB="PAY_PER_REQUEST"

# Functions

create_bucket() {

    echo "Checking if bucket s3 exist"
    if ! aws s3api head-bucket --bucket $bkt_name --region $aws_region_script 2>/dev/null >/dev/null;then
        echo "Bucket $bkt_name does not exist, creating it"

    aws s3api create-bucket \
        --bucket $bkt_name \
        --region $aws_region_script || { echo "Error while creating bucket"; exit 1; }

    aws s3api put-bucket-versioning \
        --bucket $bkt_name \
        --region $aws_region_script \
        --versioning-configuration Status=Enabled || { echo "Error while enabling bucket versioning"; exit 1; }

        
        
    aws s3api put-bucket-encryption \
        --bucket $bkt_name \
        --region $aws_region_script \
        --server-side-encryption-configuration '{"Rules" : [{"ApplyServerSideEncryptionByDefault" : {"SSEAlgorithm":"AES256"}}]}' \
        ||   { echo "Error while enabling bucket encryption"; exit 1; }
        
        echo "Bucket created,show info"
    

    
    else
        echo "Skipping bucket creation, already exist"
    fi
    
    get_bkt_info
}

get_bkt_info() {
    
    aws s3api head-bucket --bucket $bkt_name --region $aws_region_script --output json
}

create_dynamoDB(){
    echo "Checking if dynamodb table exist"

    if !  aws dynamodb describe-table --table-name $dynDB_name --region $aws_region_script 2>/dev/null >/dev/null ;then
        aws dynamodb create-table \
            --table-name $dynDB_name \
            --region $aws_region_script \
            --attribute-definitions AttributeName=LockID,AttributeType=S \
            --key-schema AttributeName=LockID,KeyType=HASH \
            --billing-mode $billing_mode_DB  >/dev/null \
            || { echo "Error while creating table"; exit 1; }
        
        echo "Table created"
    else
        echo "Skipping table creation, already exist"
    fi
    get_table_info
}   
get_table_info(){
    aws dynamodb describe-table --table-name $dynDB_name --region $aws_region_script \
    --no-cli-pager \
    | jq '{TableName: .Table.TableName, KeySchema: .Table.KeySchema, CreatedAt: .Table.CreationDateTime}'
 }
main(){
    echo "Creating resource to manage remote terraform state"
    create_bucket
    create_dynamoDB

    echo "Resources created"
}

main