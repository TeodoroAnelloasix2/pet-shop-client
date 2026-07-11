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
        stage('Create tfvars'){
            steps{
                withCredentials([file(credentialsId: 'petshop-tfvars',variable: 'f')]){
                    dir('./iac-terraform'){
                        sh('''
                        cp ${f} ./terraform.tfvars
                        terraform fmt --recursive
                        ''')
                    }
                }
            }
        }
        stage('Plan'){
            steps{
                dir('./iac-terraform'){
                    sh(''' 
                    terraform init
                    my_ip="$(curl -s ifconfig.me)/32"
                    terraform plan -out "petshop-infra-${INFRA_VERSION}" -var="public_access_cidr=${my_ip}"
                    terraform show -no-color "petshop-infra-${INFRA_VERSION}" >tfplan.txt
                    ''')
                }
            }
        }
        stage('Approved'){
            when{
                equals expected: false, actual: params.autoApprove
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
                my_ip="$(curl -s ifconfig.me)/32"
                terraform apply -lock-timeout=8m -target=module.vpc -var="public_access_cidr=${my_ip}" --auto-approve "petshop-infra-${INFRA_VERSION}"
                ''')
                }
            }
        }
        stage('Deploy whole infra'){
            steps{
                dir('./iac-terraform'){
                sh('''
                my_ip="$(curl -s ifconfig.me)/32"
                terraform apply -lock-timeout=8m -var="public_access_cidr=${my_ip}" --auto-approve "petshop-infra-${INFRA_VERSION}"
                ''')    
                }
            }
        }
    }
    post {
        always {sleep 3}
    }
}