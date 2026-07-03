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
                sh('
                aws sts assume-role --role-arn "arn:aws:iam::013484737363:role/pet-shop-jenkins-ci-role" --role-session-name test-session --no-cli-pager
                aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin
                ')
                }
            }
        }
}
