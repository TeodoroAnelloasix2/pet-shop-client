#!/usr/bin/env groovy

pipeline {
    agent {node 'jenkins-node' }
    environment {
       AWS_ACCESS_KEY_ID = credentials('pet-shop-ci-access-key-id')
       AWS_SECRET_ACCESS_KEY = credentials('SecretAccessKey-pet-shop-jenkins-ci')
       AWS_DEFAULT_REGION='us-east-1'
       ECR_REGISTRY = '013484737363.dkr.ecr.us-east-1.amazonaws.com'
       ECR_REPO = 'prod_petshop_project'
       IMAGE_VERSION = "${env.BUILD_NUMBER}"
    }
    stages {
        stage('Build'){
            steps{
                dir('./app-pet-shop/pet-shop'){
                    sh('''
                    docker build -t ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_VERSION} .
                    ''')
                }
            }
            
        }
        stage('Login Ecr'){
            steps{
                sh('''              
                aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${ECR_REGISTRY}
                ''')
                }
        }
        stage('Push'){
            steps{
                sh('''              
                docker push ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_VERSION}
                ''')
            }
        }
    }
}
        
        
