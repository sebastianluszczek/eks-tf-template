provider "aws" {
  region ="eu-central-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name                 = "eks_default"
  cidr                 = "10.0.0.0/16"
  azs                  = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_db_subnet_group" "eks_default" {
  name       = "eks_default"
  subnet_ids = module.vpc.public_subnets

  tags = {
    Name = "eks_default"
  }
}

resource "aws_db_instance" "notesdb" {
  identifier             = "eks_default"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "13.1"
  username               = "postgres"
  password               = "password"
  db_subnet_group_name   = aws_db_subnet_group.eks_default.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.education.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}

resource "aws_db_parameter_group" "eks_default" {
  name   = "eks_default"
  family = "postgres13"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

variable "db_password" {
  description = "RDS root user password"
  type        = string
  sensitive   = true
}

output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.eks_default.address
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.eks_default.port
  sensitive   = true
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.eks_default.username
  sensitive   = true
}