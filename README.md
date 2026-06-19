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
├── eks
├── how_to_run.md
├── iac-terraform
│   ├── backend.tf
│   ├── main.tf
│   ├── modules
│   │   ├── ecr
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   └── variables.tf
│   │   ├── eks
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   └── variables.tf
│   │   ├── rds_psql
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   └── variables.tf
│   │   └── vpc
│   │       ├── main.tf
│   │       ├── output.tf
│   │       └── variables.tf
│   ├── terraform.tfvars
│   └── varialbes.tf
├── jenkins
│   └── setting_up
│       ├── awscliv2.zip
│       ├── docker-compose.yaml
│       ├── Dockerfile
│       ├── dynamic
│       │   └── tls.yaml
│       ├── eksctl_Linux_amd64.tar.gz
│       ├── set_up_jenkins.sh
│       ├── terraform_1.15.5_linux_amd64.zip
│       └── traefik_certs
│           ├── local.crt
│           └── local.key
├── notes.md
├── README.md
└── scripts
    ├── create_secrets.sh
    ├── create_tfstate_remote_resources.sh
    ├── cred.env
    ├── global-bundle.pem
    └── init_login_db
        ├── bin
        │   └── executable
        ├── cmd
        │   └── app
        │       └── main.go
        ├── go.mod
        ├── go.sum
        └── internal
            ├── ctxgenerator
            │   └── ctxgenerator.go
            ├── formatSecret
            │   └── format.go
            ├── secretaws
            │   └── secret.go
            └── variables
                └── variables.go


```