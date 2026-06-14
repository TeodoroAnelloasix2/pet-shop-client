module "rds_psql" {
  source  = "terraform-aws-modules/rds/aws"
  version = "7.2.0"


  identifier = "${var.pr_name}-psql-bbdd"

  engine         = var.bd_engine
  engine_version = var.bd_version
  instance_class = var.instances_class

  family               = var.db_family
  major_engine_version = var.bd_version

  storage_encrypted     = true
  allocated_storage     = var.storage_size[0]
  max_allocated_storage = var.storage_size[1]

  #Network
  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]
  publicly_accessible    = false


  port = 5432

  skip_final_snapshot = true
  deletion_protection = false

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  db_name     = var.dbname
  username    = var.username
  password_wo = var.password
}


resource "aws_db_subnet_group" "this" {
  name        = "${var.pr_name}-subnet-group"
  subnet_ids  = var.private_subnet # Id subredes privadas 
  description = "Subnets groups for RDS"

}

resource "aws_security_group" "this" {
  name        = "${var.pr_name}-sg"
  description = "Postgress from eks nodes"
  vpc_id      = var.vpc_id
  ingress {
    description     = "eks postgresSql comunication"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.eks_sg_id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}