#!/usr/bin/env groovy

pipeline {
    agent {node 'jenkins-node' }
    stages {
        stage('test login ecr'){
            steps{
                withAWS(region:'us-east-1',credentials:'pet-shop-jenkins-ci-keys'){
                    script{
                        def login = ecrLogin()

                        sh login
                    }
                }
            }
        }
    }
}