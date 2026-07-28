# STEPS


1) Run scripts/create_tfstate_remote_resources.sh (To create resources to store terraform state file)

2) Create self-signed certificate and place them into jenkins/setting_up/traefik_certs

3) Run jenkins/setting_up/set_up_jenkins.sh (To start jenkins infra)


4) Run create-cic-cd-groups-users.sh (to create user, group , policy / attach policy to group , add user to the group )


5) run Jenkinsfile-deploy-infra.groovy to deloy  AWS infra

    start aws infra: 
```sh
  - terraform apply -target=module.vpc -var="public_access_cidr=$(curl -s ifconfig.me)/32" --auto-approve
  - terraform apply -var="public_access_cidr=$(curl -s ifconfig.me)/32" --auto-approve
  - script/eks_config_alb_components.sh
```
6) run jenkinsfile-pet-shop-ci.groovy ( to build and push image )


7) run jenkinsfile-pet-shop-ci.groovy 

```sh
  - Add certificate arn: sh -> cd eks/overlay/prod &&  kustomize edit add annotation alb.ingress.kubernetes.io/certificate-arn:${CERT_ARN} 
  - kustomize edit set image pet-shop-to-customize=013484737363.dkr.ecr.us-east-1.amazonaws.com/prod_petshop_project:${tag} 
  - aws eks update-kubeconfig --region us-east-1 --name pet-shop-cluster --kubeconfig ./petshop.config --no-cli-pager
  - create namespace  kubectl --kubeconfig ../petshop.config apply -f namespace.yaml
  - kubectl apply -k overlays/prod/ --kubeconfig ./petshop.config

```