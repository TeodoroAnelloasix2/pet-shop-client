#!/usr/bin/env bash

##################################
#                                #   
#  Developer: TeodoroAnelloasix2 #
#  Environment: Free tier aws    #
#                                #
##################################

set -euo pipefail


# Variables
cicd_group="DevopsGroup"
cicd_user="jenkins"
cicd_quey="Users[?UserName=='${cicd_user}'].Arn"
jenkins_user_arn=""
# Functions

Create_group(){
    echo "Creating group for devops operations"
    echo "Checking if group already exists"

    if ! aws iam get-group --group-name "$cicd_group" 2>/dev/null >/dev/null ;then
        echo "Creating devops group"
        aws iam create-group --group-name "$cicd_group" --no-cli-pager || { echo "Failed to create group, aborting"; exit 1; }
        echo "Group successfully created"
    else
        echo "Devops group already exist, skipping step"
        aws iam get-group --group-name "$cicd_group"  --no-cli-pager --query "{Users: Users[*].UserName, GroupName: Group.GroupName }" --output table \
        || { echo "Failed to retrieve group info, it does exist ?"; exit 1; }
    fi
}

Create_user(){
    echo "Creating jenkins user to manage ci/cd processes"
    echo "Checking if user already exists"
    if ! aws iam get-user --user-name "$cicd_user" 2>/dev/null >/dev/null ;then
        echo "Creating jenkins user"
        aws iam create-user --user-name  "$cicd_user" --no-cli-pager || { echo "Failed to create group, aborting"; exit 1; }
        echo "User successfully created"
    else
        echo "User already exists"
        aws iam get-user --user-name "$cicd_user" --no-cli-pager --query "{User: User.UserName,Arn: User.Arn}" --output table \
        || { echo "Failed to retrieve user info, it does exist ?"; exit 1; }
    fi
}

Insert_User_into_Group(){
    echo "Checking if user ${cicd_user} is present into ${cicd_group}"
    jenkins_user_arn=$(aws iam get-group --group-name "${cicd_group}" --no-cli-pager --query "${cicd_quey}" --output text )
    if [[ -z "${jenkins_user_arn}" ]];then
        echo "Adding ${cicd_user} into group ${cicd_group}"
        aws iam add-user-to-group --user-name "${cicd_user}"  --group-name "${cicd_group}" --no-cli-pager 
    else
        echo "User ${cicd_user} already present into group"
    fi
}

main(){
    Create_group
    Create_user
    Insert_User_into_Group
}

main