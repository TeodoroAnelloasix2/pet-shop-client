module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  # Cluster 
  name                                     = var.cluster_name
  kubernetes_version                       = var.kubernetes_version
  enable_cluster_creator_admin_permissions = true

  security_group_id = aws_security_group.this.id
  # Network
  vpc_id     = var.petshop_vpc_id
  subnet_ids = var.private_subnet_id

  # Endpoint access
  endpoint_public_access       = true
  endpoint_private_access      = true
  endpoint_public_access_cidrs = var.public_access_cidr
  # Logging
  enabled_log_types                      = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  cloudwatch_log_group_retention_in_days = 7

  # Components
  addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent    = true
      before_compute = true
    }
  }
  eks_managed_node_groups = {
    ng-1 = {

      instance_types = ["t3.small"]

      min_size     = 2
      max_size     = 5
      desired_size = 2
      tags = {
        Name = "${var.cluster_name}-node-group-1"
      }
    }
    ng-2 = {

      instance_types = ["t3.small"]

      min_size     = 2
      max_size     = 5
      desired_size = 2
      tags = {
        Name = "${var.cluster_name}-node-group-2"
      }
    }
  }
}

resource "aws_security_group" "this" {
  name = "${var.pr_name}-eks-sg"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}