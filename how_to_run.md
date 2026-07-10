# STEPS


1) Run scripts/create_tfstate_remote_resources.sh (To create resources to store terraform state file)

2) Create self-signed certificate and place them into jenkins/setting_up/traefik_certs

3) Run jenkins/setting_up/set_up_jenkins.sh (To start jenkins infra)


4) 

/ Developing pipeline to deloy  AWS infra
start aws infra: 
    - terraform apply -target=module.vpc -var="public_access_cidr=$(curl -s ifconfig.me)/32" --auto-approve
    - terraform apply -var="public_access_cidr=$(curl -s ifconfig.me)/32" --auto-approve


4) Create user, group , policy / attach policy to group , add user to the group


6) create namespace  kubectl --kubeconfig ../petshop.config apply -f namespace.yaml
//

// DEPLOY CLUSTER INFRA // todo pipeline

7) Add certificate arn: sh -> kustomize edit add annotation alb.ingress.kubernetes.io/certificate-arn:${CERT_ARN}

8) run script/eks_config_alb_components.sh

9) kubectl apply -k overlays/prod/ --kubeconfig ./petshop.config
////////////

5) RUN  https://jenkins/job/pet-shop/job/pet-shop-CI/ which execute jenkinsfile-pet-shop-ci.groovy

Steps 

build app, get ecr info:

   ecr_repo=$(aws ecr describe-repositories --region us-east-1 --query "repositories[?repositoryName=='prod_petshop_project'].repositoryUri" --no-cli-pager --output text)
   
   docker build -t $ecr_repo:dev1 .
   
   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 013484737363.dkr.ecr.us-east-1.amazonaws.com






