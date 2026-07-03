#!/usr/bin/env groovy

pipeline {
    agent {node 'jenkins-node' }
    environment {
       AWS_ACCESS_KEY_ID = credentials('pet-shop-ci-access-key-id')
       AWS_SECRET_ACCESS_KEY = credentials('SecretAccessKey-pet-shop-jenkins-ci')
       AWS_DEFAULT_REGION='us-east-1'
    }
    stages {
        stage('test login ecr'){
            steps{
                sh('''              
                aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 013484737363.dkr.ecr.us-east-1.amazonaws.com
                ''')
                }
            }
        }
}
