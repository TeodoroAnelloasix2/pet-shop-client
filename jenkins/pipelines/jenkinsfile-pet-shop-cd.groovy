#!/usr/bin/env groovy
pipeline{
    agent { node 'jenkins-node' }
    environment{
        AWS_ACCESS_KEY_ID = credentials('jenkins-user-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-user-secret-access-key')
        AWS_DEFAULT_REGION='us-east-1'
        CERT_ARN=credentials('petshop-certificate-arn')
    }
    stages{
        stage('kustomize ingress'){
            steps{
                dir('eks/overlays/prod'){
                    sh('''
                    kustomize edit add annotation alb.ingress.kubernetes.io/certificate-arn:${CERT_ARN}
                    ''')
                }
            }
        }
        stage('kustomize image'){
            steps{
                dir('eks/overlays/prod'){
                sh('''
                #!/bin/bash
                last_tag=$(aws ecr list-images --repository-name prod_petshop_project --filter tagStatus=TAGGED,imageStatus=ACTIVE  --query 'imageIds[*].imageTag' --output json | jq -r '.[-1]')
                kustomize edit set image pet-shop-to-customize=013484737363.dkr.ecr.us-east-1.amazonaws.com/prod_petshop_project:${last_tag}
                ''')
                }
            }
        }
        stage('Create namespace'){
            steps{
                dir('eks/base'){
                sh('''
                aws eks update-kubeconfig --region us-east-1 --name pet-shop-cluster --kubeconfig ./petshop.config --no-cli-pager
                kubectl --kubeconfig ./petshop.config apply -f namespace.yaml
                ''')
                }
            }
        }
        stage('Apply kustomization infra'){
            steps{
                dir('eks/overlays/prod'){
                sh('''
                aws eks update-kubeconfig --region us-east-1 --name pet-shop-cluster --kubeconfig ./petshop.config --no-cli-pager
                kubectl --kubeconfig ./petshop.config apply -k .
                ''')
                }
            }
        }
        stage('Update iamserviceaccount'){
            steps{
                dir('eks/overlays/prod'){
                    sh('''
                    kubectl --kubeconfig ./petshop.config set serviceaccount \
                    deployment/pet-shop-deployment \
                    pet-shop-mandatoryresources-allow-svc-account \
                    -n pet-shop-prod
                
                    kubectl --kubeconfig ./petshop.config rollout restart \
                    deployment/pet-shop-deployment -n pet-shop-prod
                
                    kubectl --kubeconfig ./petshop.config rollout status \
                    deployment/pet-shop-deployment -n pet-shop-prod --timeout=5m
                    
                    ''')
                }
            }
        }
    }
    post {
        always{sleep 3}
    }
}