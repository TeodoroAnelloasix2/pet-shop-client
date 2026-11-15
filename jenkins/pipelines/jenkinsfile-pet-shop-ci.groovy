#!/usr/bin/env groovy

pipeline {
    agent {node 'jenkins-node' }
    environment {
       AWS_ACCESS_KEY_ID = credentials('jenkins-user-access-key')
       AWS_SECRET_ACCESS_KEY = credentials('jenkins-user-secret-access-key')
       AWS_DEFAULT_REGION='us-east-1'
       ECR_REGISTRY = '013484737363.dkr.ecr.us-east-1.amazonaws.com'
       ECR_REPO = 'prod_petshop_project'
       IMAGE_VERSION = "${env.BUILD_NUMBER}"
    }
    stages {
        stage('Unit test'){
            steps{
                dir('./app-pet-shop/app'){
                    sh('''
                    docker run --rm -v $(pwd):/app -w /app golang:1.25.5-alpine3.23 go test ./... -v
                    ''')
                }
            }
        }
        stage('Build'){
            steps{
                dir('./app-pet-shop'){
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
    post {
        always {sleep 3}
    }
}
        
        
