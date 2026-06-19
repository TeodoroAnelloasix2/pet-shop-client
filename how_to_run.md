# STEPS


1) Run scripts/create_tfstate_remote_resources.sh (To create resources to store terraform state file)

2) Create self-signed certificate and place them into jenkins/setting_up/traefik_certs

3) Run jenkins/setting_up/set_up_jenkins.sh (To start jenkins infra)

3) start aws infra: 
    - terraform apply -target=module.vpc -var="public_access_cidr=$(curl -s ifconfig.me)/32" --auto-approve
    - terraform apply -var="public_access_cidr=$(curl -s ifconfig.me)/32" --auto-approve
