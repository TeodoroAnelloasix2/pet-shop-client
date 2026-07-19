#!/usr/bin/env bash

##################################
#                                #   
#  Developer: TeodoroAnelloasix2 #
#  Environment: Free tier aws    #
#                                #
##################################

# Variables

aws_region="us-east-1"
cluster_name="pet-shop-cluster"
policy_name="${cluster_name}-eks-components-policy"
json_doc="iam-alb-policy.json"
policy_alb_query="Policies[?PolicyName=='${policy_name}'].Arn"
policy_mandatory_resources="pet-shop-mandatoryresources-allow"
policy_mandatory_resources_query="Policies[?PolicyName=='${policy_mandatory_resources}'].Arn"
svc_account_name="${policy_name}-svc-account"
svc_account_policy_mandatory_resources="${policy_mandatory_resources}-svc-account"
policy_arn=""
base_eks="../eks"
namespace_file="${base_eks}/base/namespace.yaml"
namespace="kube-system"
cfg_file="${base_eks}/petshop.config"
alb_repo_eks="https://aws.github.io/eks-charts"
service_account_name="petshop-alb-controller"

stack_name_patten="eksctl-pet-shop-cluster-addon-iamserviceaccount"
stack_query="Stacks[?contains(StackName,'${stack_name_patten}')].StackId"

set -euo pipefail


Clean_stacks(){
    echo "Deleting olds iam service accounts"
    mapfile -t stack_ids < <(aws cloudformation describe-stacks   --query "${stack_query}" --no-cli-pager --output text )
    for id in "${stack_ids[@]}"; do
        if [[ ! -z "$id" ]];then
            echo "Deleting  ${id}"
            if aws cloudformation delete-stack --stack-name "$id" --region "$aws_region"; then

                aws cloudformation wait stack-delete-complete --stack-name "$id" --region "$aws_region" || { echo "Timeout or error waiting for stack: ${id}"; exit 1; }
            else 
                echo "Failed to initiate deletion for stack: ${id}"
                exit 1
            fi
        fi
    done
    echo "Done"
}

Get_policy_arn(){
    policy_arn=$(aws iam list-policies --query "$1" --output text )
}


Create_policy_iamserviceaccount(){
    echo "Get manage cluster components policy arn"
    Get_policy_arn $policy_alb_query
    if [[ -z "$policy_arn" ]];then
    
        echo "Creating new policy"
        aws iam create-policy --policy-name "$policy_name" --policy-document file://"$json_doc" || { echo "Failed to create policy, aboritng"; exit 1; }
        sleep 1
        Get_policy_arn $policy_alb_query
    fi
    
    eksctl create iamserviceaccount --region "$aws_region" \
    --namespace="$namespace"    \
    --cluster="$cluster_name"  \
    --name="$svc_account_name" \
    --attach-policy-arn="$policy_arn" \
    --override-existing-serviceaccounts \
    --approve || { echo "Failed to create service account, aborting" ; exit 1; }

}

Create_policy_iamserviceaccount_mandatory_resources(){
    echo "Get mandatory resources policy arn"
    Get_policy_arn "$policy_mandatory_resources_query"
    if  [[ -z "$policy_arn" ]];then
        echo "Failed to get policy arn, it does exists ? Aborting"
        exit 1
    fi
    
    eksctl create iamserviceaccount --region "$aws_region" \
    --namespace="$namespace"    \
    --cluster="$cluster_name"  \
    --name="$svc_account_policy_mandatory_resources" \
    --attach-policy-arn="$policy_arn" \
    --override-existing-serviceaccounts \
    --approve || { echo "Failed to create service account (policy mandatory resources), aborting" ; exit 1; }
}

Create_config_file(){
    aws eks update-kubeconfig --region "$aws_region"   \
      --name "$cluster_name" \
      --kubeconfig "$cfg_file" \
      --no-cli-pager || { echo "Failed to create config file, aborting" ; exit 1; }
}

Install_alb_controller(){

    helm repo add eks "$alb_repo_eks" || { echo "Failed to add helm repo, aborting" ; exit 1; }
    
    helm repo update || { echo "Failed to update helm repo, aborting" ; exit 1; }
    
    helm  --kubeconfig "$cfg_file"  upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
        --namespace="$namespace" \
        --set clusterName="$cluster_name" \
        --set serviceAccount.create=false \
        --set serviceAccount.name="$svc_account_name" \
        --set region="$aws_region" \
        --set vpcId=$(aws ec2 describe-vpcs --query "Vpcs[?Tags[?Key=='Name' && Value=='pet-shop-vpc']].VpcId" --output text --no-cli-pager) \
        || { echo "Failed to install eks/aws-load-balancer-controller, aborting" ; exit 1; }

}

CreateOIDC(){
    eksctl utils associate-iam-oidc-provider --region "$aws_region" --cluster "$cluster_name"  || \
        { echo "Failed to create OpenID Connect, aborting" ; exit 1; }
}

main(){
    Create_config_file
    Clean_stacks
    CreateOIDC
    Create_policy_iamserviceaccount
    Create_policy_iamserviceaccount_mandatory_resources
    Install_alb_controller
}

main "$@"