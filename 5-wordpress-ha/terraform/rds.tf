module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  identifier = var.rds_name
  multi_az   = true

  engine            = "mysql"
  engine_version    = "5.7.19"
  instance_class    = "db.t2.small"
  allocated_storage = 20

  name     = var.rds_database
  username = var.rds_master_user
  password = var.rds_master_user_password
  port     = "3306"

  iam_database_authentication_enabled = false

  vpc_security_group_ids = [aws_security_group.rds.id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"


  # DB subnet group
  subnet_ids = module.vpc.database_subnets


  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "demodb"

  # Database Deletion Protection
  deletion_protection = false

}


resource "aws_security_group" "rds" {
  name        = "allow_vpc"
  description = "Allow vpc"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
