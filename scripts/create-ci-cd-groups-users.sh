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
cicd_query="Users[?UserName=='${cicd_user}'].Arn"
jenkins_user_arn=""
policy_arn=""
policy_name="DevopsPolicy"
policy_query="Policies[?PolicyName=='${policy_name}'].Arn"
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
    jenkins_user_arn=$(aws iam get-group --group-name "${cicd_group}" --no-cli-pager --query "${cicd_query}" --output text )
    if [[ -z "${jenkins_user_arn}" ]];then
        echo "Adding ${cicd_user} into group ${cicd_group}"
        aws iam add-user-to-group --user-name "${cicd_user}"  --group-name "${cicd_group}" --no-cli-pager \
        || { echo "Failed to add user at the group, aborting"; exit 1; }
    else
        echo "User ${cicd_user} already present into group"
    fi
}

Create_policy(){
    echo "Creating Devops policies"
    policy_arn=$(aws iam list-policies --query $policy_query --output text)
    if [[ -z "$policy_arn" ]];then
        echo "Policy does not exist, creating it"
        aws iam create-policy --policy-name "$policy_name" --policy-document file://devops_cicd_policy.json --no-cli-pager \
        || { echo "Failed to create devops policy, aborting"; exit 1; }
        echo "Policy successfully created"
    else
        echo "Policy already exist,skipping step"
    fi
}
Attach_policy_group(){
    echo "Attaching policy at the group"
    policy_arn=$(aws iam list-policies --query $policy_query --output text)
    aws iam attach-group-policy --group-name "$cicd_group" --policy-arn "$policy_arn"  \
    || { echo "An error occurred giving permission at the group, aborting"; exit 1; }
    echo "Policy attached at the group"
}
main(){
    Create_group
    Create_user
    Insert_User_into_Group
    Create_policy
    Attach_policy_group
}

main