#!/usr/bin/env groovy

pipeline {
    agent {node 'jenkins-node' }
    stages {
        stage('test login ecr'){
            steps{
                withAWS(
                        region:'us-east-1',
                        credentials:'pet-shop-jenkins-ci-keys',
                        role: 'pet-shop-jenkins-ci-role',
                        roleAccount: '013484737363',
                        roleSessionName: 'petshop-ci-session'
                    ){
                    script{
                        def login = ecrLogin()

                        sh login
                    }
                }
            }
        }
    }
}