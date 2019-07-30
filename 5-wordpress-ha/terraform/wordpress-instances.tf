resource "aws_security_group" "wordpress" {
  name        = "allow_HTTP_cidr"
  description = "Allow HTTP"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




# resource "aws_instance" "wordpress_1" {
#   ami                    = "${lookup(var.ec2_amis, var.aws_region)}"
#   instance_type          = "t2.small"
#   subnet_id              = module.vpc.private_subnets[0]
#   vpc_security_group_ids = [aws_security_group.wordpress.id]

#   tags = {
#     Owner = var.owner
#     Name  = "wordpress-1"
#   }

#   user_data = <<EOF
# #! /bin/bash
# docker run -d --restart unless-stopped --name wordpress \
#     -p 80:80 \
#     -e WORDPRESS_DB_HOST="${split(":", module.db.this_db_instance_endpoint)[0]}" \
#     -e WORDPRESS_DB_USER="${var.rds_master_user}" \
#     -e WORDPRESS_DB_PASSWORD="${var.rds_master_user_password}" \
#     -e WORDPRESS_DB_NAME="${var.rds_database}" \
#     wordpress:php7.3-apache 
# EOF
# }

# resource "aws_instance" "wordpress_2" {
#   ami = "${lookup(var.ec2_amis, var.aws_region)}"
#   instance_type = "t2.small"
#   subnet_id = module.vpc.private_subnets[1]
#   vpc_security_group_ids = [aws_security_group.wordpress.id]

#   tags = {
#     Owner = var.owner
#     Name = "wordpress-2"
#   }

#   user_data = <<EOF
# #! /bin/bash
# docker run -d --restart unless-stopped --name wordpress \
#     -p 80:80 \
#     -e WORDPRESS_DB_HOST="${split(":", module.db.this_db_instance_endpoint)[0]}" \
#     -e WORDPRESS_DB_USER="${var.rds_master_user}" \
#     -e WORDPRESS_DB_PASSWORD="${var.rds_master_user_password}" \
#     -e WORDPRESS_DB_NAME="${var.rds_database}" \
#     wordpress:php7.3-apache 
# EOF
# }


module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = "wordpress"

  # Launch configuration
  lc_name = "wp-lc"

  image_id        = "${lookup(var.ec2_amis, var.aws_region)}"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.wordpress.id]

  user_data = <<EOF
#!/bin/bash
docker run -d --restart unless-stopped --name wordpress \
    -p 80:80 \
    -e WORDPRESS_DB_HOST="${split(":", module.db.this_db_instance_endpoint)[0]}" \
    -e WORDPRESS_DB_USER="${var.rds_master_user}" \
    -e WORDPRESS_DB_PASSWORD="${var.rds_master_user_password}" \
    -e WORDPRESS_DB_NAME="${var.rds_database}" \
    wordpress:php7.3-apache 
EOF


  ebs_block_device = [
    {
      device_name = "/dev/xvdz"
      volume_type = "gp2"
      volume_size = "50"
      delete_on_termination = true
    },
  ]

  root_block_device = [
    {
      volume_size = "30"
      volume_type = "gp2"
    },
  ]

  # Auto scaling group
  asg_name = "wp-asg"
  vpc_zone_identifier = module.vpc.private_subnets
  health_check_type = "EC2"
  min_size = 2
  max_size = 4
  desired_capacity = 2
  wait_for_capacity_timeout = 0
  target_group_arns = module.alb.target_group_arns

  tags = [
    {
      key = "Environment"
      value = "dev"
      propagate_at_launch = true
    },
  ]

}
