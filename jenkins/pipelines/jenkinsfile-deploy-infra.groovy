#!/usr/bin/env groovy

pipeline{
    agent { node 'jenkins-node' }
    environment{
        AWS_ACCESS_KEY_ID = credentials('jenkins-user-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-user-secret-access-key')
        AWS_DEFAULT_REGION='us-east-1'
        INFRA_VERSION = "${env.BUILD_NUMBER}"
    }
    parameters{
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }
    stages{
        stage('Plan'){
            steps{
                dir('./iac-terraform'){
                    sh(''' 
                    terraform init
                    terraform plan -out "petshop-infra-${INFRA_VERSION}" -var="public_access_cidr=$(curl -s ifconfig.me)/32"
                    terraform show -no-color "petshop-infra-${INFRA_VERSION}" >tfplan.txt
                    ''')
                }
            }
        }
        stage('Approved'){
            when{
                not {
                    equals expected: true,actual: params.autoApprove
                }
            }
            steps{
                dir('./iac-terraform'){
                    script{
                    def plan=readFile 'tfplan.txt'
                    input message: "Do you want to apply the plan petshop-infra-${INFRA_VERSION}",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                    }
                }
            }
        }
        stage('Module vpc'){
            steps{
                dir('./iac-terraform'){
                sh('''
                terraform apply -target=module.vpc -var="public_access_cidr=$(curl -s ifconfig.me)/32" --auto-approve "petshop-infra-${INFRA_VERSION}"
                ''')
                }
            }
        }
        stage('Deploy whole infra'){
            steps{
                dir('./iac-terraform'){
                sh('''
                terraform apply -var="public_access_cidr=$(curl -s ifconfig.me)/32" --auto-approve "petshop-infra-${INFRA_VERSION}"
                ''')    
                }
            }
        }
    }
    post {
        always {sleep 3}
    }
}