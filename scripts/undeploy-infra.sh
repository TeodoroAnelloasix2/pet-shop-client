#!/usr/bin/env bash

##################################
#                                #   
#  Developer: TeodoroAnelloasix2 #
#  Environment: Free tier aws    #
#                                #
##################################

set -euo pipefail

ecr_repository="prod_petshop_project"
ecr_query="repositories[?contains(repositoryArn,'${ecr_repository}')].repositoryArn"
ecr_arn=""
ingress_name="petshop-prod-ingress"
alb_query="LoadBalancers[?contains(LoadBalancerArn,'${ingress_name}')]"
alb_arn=""
aws_region="us-east-1"

Delete_alb(){
    echo "Deleting Application  load balancer"
    alb_arn=$(aws elbv2 describe-load-balancers  --region us-east-1 --query "${alb_query}" --no-cli-pager  --no-cli-pager --output text)
    if [[ ! -z "$alb_arn" ]] ;then
        echo "Application load balancer already deleted, nothing to do"
    else
        echo "Deleting ${alb_arn}"
        aws elbv2 delete-load-balancer --load-balancer-arn "$alb_arn"  || \
        { echo "error deleting alb, aborting"; exit 1; }
    fi
}

Delete_images(){
    echo "Deleting images"
    ecr_arn=$(aws ecr describe-repositories --no-cli-pager --region "${aws_region}" --query "${ecr_query}" --output text)
    image_list=$(aws ecr list-images --repository-name "$ecr_repository"  --region "$aws_region" --no-cli-pager  --output json)
    img_num=$(echo "$image_list" | jq '.[] | length')
    if [[ ! -z "ecr_arn" ]];then 
        echo -e "Deleting images from repository \n ${ecr_arn}"
        if [[ "$img_num" -gt 0 ]];then
            aws ecr batch-delete-image \
            --repository-name "$ecr_repository"   \
            --images-ids  "$image_list" --region "$aws_region" \
            || { echo "Error deleting images, aborting it"; exit 1; }
        fi
        echo "Images deleted"
    
    else
        echo "No ecr repositoy found, skipping step"
    fi
       
}

main(){
    Delete_images
    Delete_alb
}

main