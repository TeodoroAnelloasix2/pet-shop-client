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
policies_query="Policies[?PolicyName=='${policy_name}'].Arn"
svc_account_name="${policy_name}-svc-account"
policy_arn=""
base_eks="../eks"
namespace_file="${base_eks}/namespace.yaml"
namespace=""
cfg_file="${base_eks}/petshop.config"

set -euo pipefail

eksctl utils associate-iam-oidc-provider --region "$aws_region" --cluster "$cluster_name" 

Get_policy_arn(){
    policy_arn=$(aws iam list-policies --query "$policies_query" --output text )    
}

Create_policy_iamserviceaccount(){
    echo "Get manage cluster components policy arn"
    Get_policy_arn
    if [[ ! -z "$policy_arn" ]];then
        echo "Deleting previous policy" 
        aws iam delete-policy --policy-arn "$policy_arn" || { echo "Failed to delete previous policy, aborting"; exit 1; }
        sleep 1
    fi
    echo "Creating new policy"
    aws iam create-policy --policy-name "$policy_name" --policy-document file://"$json_doc" || { echo "Failed to create policy, aboritng"; exit 1; }
    Get_policy_arn
    
    eksctl create iamserviceaccount --region "$aws_region" \
    --namespace=kube-system    \
    --cluster="$cluster_name"  \
    --name="$svc_account_name" \
    --attach-policy-arn="$policy_arn" \
    --override-existing-serviceaccounts \
    --approve || { echo "Failed to create service account, aborting" ; exit 1; }

}

Create_config_file(){
    aws eks update-kubeconfig --region "$aws_region"   \
      --name "$cluster_name" \
      --kubeconfig "$cfg_file" \
      --no-cli-pager || { echo "Failed to create config file, aborting" ; exit 1; }
}

Create_namespace(){
    Create_config_file
    kubectl --kubeconfig "$cfg_file" apply -f "$namespace_file" || { echo "Failed to create namespace, aborting" ; exit 1; }
}

main(){
    Create_namespace
    Create_policy_iamserviceaccount
}

main "$@"