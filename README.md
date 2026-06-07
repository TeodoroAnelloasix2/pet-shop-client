# Pet-shop - Cloud Native Application on AWS EKS

### Project Overview

This project demonstrates my Devops capabilities by building a **cloud-antive application** from sratch on AWS.
The entire infrastructure is managed as a code, with automated CI/CD pipelines and running on kubernetes.

### Architecture

- **Application**: Golang web app (containerized)
- **Orchestration**: AWS EKS (Kubernetes)
- **Infrastructure as Code**: Terraform (remote state on S3 + DynamoDB locking)
- **CI/CD**: Jenkins pipeline (build → test → push → deploy)
- **Storage**: S3 bucket (static assets) + DynamoDB (user data/sessions)

### Project structure
```sh
.
├── app-pet-shop
├── iac-terraform
│   └── bucket-s3
├── k8s
├── pipelines
├── README.md
└── scripts
    └── create_tfstate_remote_resources.sh

```