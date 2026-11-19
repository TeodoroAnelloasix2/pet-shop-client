#!/usr/bin/env bash

##################################
#                                #   
#  Developer: TeodoroAnelloasix2 #
#  Environment: Free tier aws    #
#                                #
##################################

set -euo pipefail

vpc_name="pet-shop-vpc"
vpc_filter="Name=tag:Name,Values=${vpc_name}" "Name=tag:Environment,Values=prod"
vpc_id=""


Get_vpc_id(){
    echo "Getting vpc id"
    vpc_id=$(aws ec2 describe-vpcs  --filters "$vpc_filter" --query="Vpcs[*].VpcId" --output text )
    if [[ -z "$vpc_id" ]];then
        echo "Vpc id successfully obtained: ${vpc_id}"
    else
        echo "Error: No vpc found; aborting process"
        exit 1
    fi
}



