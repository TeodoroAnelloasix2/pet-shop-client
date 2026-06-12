module "rds_psql" {
  source = "terraform-aws-modules/rds/aws"
  version = "7.2.0"
  
  subnet_ids = var.private_subnet
  identifier = "${var.pr_name}-psql-bbdd"
  engine = var.bd_engine
  engine_version = var.bd_version
  family =var.db_family
  major_engine_version = var.bd_version
  instance_class = var.instances_class

}