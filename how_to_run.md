# STEPS


1) Run scripts/create_tfstate_remote_resources.sh (To create resources to store terraform state file)

2) Create self-signed certificate and place them into jenkins/setting_up/traefik_certs

3) Run jenkins/setting_up/set_up_jenkins.sh (To start jenkins infra)

3) start aws infra: 
    - terraform apply -target=module.vpc -var="public_access_cidr=$(curl -s ifconfig.me)/32" --auto-approve
    - terraform apply -var="public_access_cidr=$(curl -s ifconfig.me)/32" --auto-approve

4) Create user, group , policy / attach policy to group , add user to the group

5) build app, get ecr info:  //TODO (Use Jenkins pipeline)

   ecr_repo=$(aws ecr describe-repositories --region us-east-1 --query "repositories[?repositoryName=='prod_petshop_project'].repositoryUri" --no-cli-pager --output text)
   
   docker build -t $ecr_repo:dev1 .
   
   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 013484737363.dkr.ecr.us-east-1.amazonaws.com


6) create namespace  kubectl --kubeconfig ../petshop.config apply -f namespace.yaml 

7) run script/eks_config_alb_components.sh

8) kubectl apply -k overlays/prod/ --kubeconfig ./petshop.config



