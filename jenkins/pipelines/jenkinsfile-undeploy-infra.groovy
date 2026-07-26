#!/usr/bin/env groovy

pipeline{
    agent { node 'jenkins-node' }
    environment {
        AWS_ACCESS_KEY_ID = credentials('jenkins-user-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-user-secret-access-key')
        AWS_DEFAULT_REGION='us-east-1'
    }
    stages{
        stage('Delete alb y ecr images'){
            steps{
                dir('./scripts'){
                sh('''
                    ./undeploy-infra.sh
                ''')
                }
            }
        }
        stage('Delete eks'){
            steps{
                dir('./iac-terraform'){
                    sh('''
                    my_ip="$(curl -s ifconfig.me)/32"
                    terraform destroy --target=molude.eks  -var="public_access_cidr=${my_ip}" --auto-approve
                    ''')
                }
            }
        }
        stage('Delete ecr'){
            steps{
                dir('./iac-terraform'){
                    sh('''
                    my_ip="$(curl -s ifconfig.me)/32"
                    terraform destroy --target=molude.ecr  -var="public_access_cidr=${my_ip}" --auto-approve
                    ''')
                }
            }
        }
         stage('Delete infra'){
            steps{
                dir('./iac-terraform'){
                    sh('''
                    my_ip="$(curl -s ifconfig.me)/32"
                    terraform destroy -var="public_access_cidr=${my_ip}" --auto-approve
                    ''')
                }
            }
        }
    }
    post {
        always {sleep 3}
    }
}