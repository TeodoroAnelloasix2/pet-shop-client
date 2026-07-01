#!/usr/bin/env groovy

pipeline {
    agent 'jenkins-node'
    stages {
        stage('test'){
            steps{
                withAWS(region:'us-east-1',credentials:'pet-shop-jenkins-ci-keys'){
                    script{
                        sh """
                            aws ecr describe-repositories
                        """
                    }
                }
            }
        }
    }
}