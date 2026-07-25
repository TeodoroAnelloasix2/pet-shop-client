# Pet-shop - Cloud Native Application on AWS EKS

### Project Overview

This project demonstrates my Devops capabilities by building a **cloud-antive application** from sratch on AWS.
The entire infrastructure is managed as a code, with automated CI/CD pipelines and running on kubernetes.

### Architecture

- **Application**: Golang web app (containerized)
- **Orchestration**: AWS EKS (Kubernetes)
- **Infrastructure as Code**: Terraform (remote state on S3 + DynamoDB locking)
- **CI/CD**: Jenkins pipeline (build → test → push → deploy)
- **Storage**: S3 bucket (static assets) + DynamoDB (login)

### Project structure

```sh
.
├── app-pet-shop
│   └── pet-shop
│       ├── cmd
│       │   └── app
│       │       └── main.go
│       ├── Dockerfile
│       ├── go.mod
│       ├── go.sum
│       ├── internal
│       │   ├── ctxgenerator
│       │   │   └── ctxgenerator.go
│       │   ├── formatsecret
│       │   │   └── format.go
│       │   ├── httpserver
│       │   │   ├── handlers.go
│       │   │   └── server.go
│       │   ├── secretaws
│       │   │   └── secret.go
│       │   └── variables
│       │       └── variables.go
│       └── resources
│           ├── images
│           │   └── pet.jpg
│           └── templates
│               ├── home.css
│               ├── home.html
│               ├── login.html
│               ├── register.html
│               └── user.html
├── eks
│   ├── base
│   │   ├── deployment.yaml
│   │   ├── ingress.yaml
│   │   ├── kustomization.yaml
│   │   ├── namespace.yaml
│   │   └── service.yaml
│   ├── overlays
│   │   └── prod
│   │       ├── kustomization.yaml
│   │       └── serviceaccount-deployment-patch.yaml
│   └── petshop.config
├── how_to_run.md
├── iac-terraform
│   ├── backend.tf
│   ├── main.tf
│   ├── modules
│   │   ├── ecr
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   └── variables.tf
│   │   ├── eks
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   └── variables.tf
│   │   ├── iam
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   └── varaibles.tf
│   │   ├── rds_psql
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   └── variables.tf
│   │   ├── s3
│   │   │   ├── main.tf
│   │   │   └── varaibles.tf
│   │   └── vpc
│   │       ├── main.tf
│   │       ├── output.tf
│   │       └── variables.tf
│   ├── terraform.tfvars
│   └── varialbes.tf
├── jenkins
│   ├── pipelines
│   │   ├── jenkinsfile-deploy-infra.groovy
│   │   ├── jenkinsfile-pet-shop-cd.groovy
│   │   └── jenkinsfile-pet-shop-ci.groovy
│   └── setting_up
│       ├── awscliv2.zip
│       ├── docker-compose.yaml
│       ├── Dockerfile
│       ├── dynamic
│       │   └── tls.yaml
│       ├── eksctl_Linux_amd64.tar.gz
│       ├── helm-v4.2.3-linux-amd64.tar.gz
│       ├── kubectl-1.36.tar.gz
│       ├── kustomize-v5.8.1.tar.gz
│       ├── set_up_jenkins.sh
│       ├── terraform_1.15.5_linux_amd64.zip
│       └── traefik_certs
│           ├── local.crt
│           └── local.key
├── notes.md
├── README.md
└── scripts
    ├── create-ci-cd-groups-users.sh
    ├── create_secrets.sh
    ├── create_tfstate_remote_resources.sh
    ├── cred.env
    ├── devops_cicd_policy.json
    ├── eks_config_alb_components.sh
    ├── global-bundle.pem
    ├── iam-alb-policy.json
    ├── jenkins-user-assume-policy.json
    ├── pet-shop-jenkins-ci-role.json
    └── private-ecr-policy-pet-shop-ci.json
```