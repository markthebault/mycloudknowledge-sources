resource "aws_security_group" "wordpress" {
  name        = "allow_HTTP"
  description = "Allow HTTP"
  vpc_id      = aws_vpc.example.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow_all" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"] #your IP here!!!!


  security_group_id = aws_security_group.wordpress.id
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/id_rsa.pub")
}


resource "aws_instance" "wordpress" {
  ami           = "${lookup(var.ec2_amis, var.aws_region)}"
  instance_type = "t2.small"

  subnet_id                   = aws_subnet.example_public_az2.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.deployer.id

  vpc_security_group_ids = [aws_security_group.wordpress.id]

  tags = {
    Owner = var.owner
    Name  = "wordpress"
  }

  user_data = <<EOF
#! /bin/bash
docker run -d --restart unless-stopped --name wordpress \
    -p 80:80 \
    -e WORDPRESS_DB_HOST="${split(":", module.db.this_db_instance_endpoint)[0]}" \
    -e WORDPRESS_DB_USER="${var.rds_master_user}" \
    -e WORDPRESS_DB_PASSWORD="${var.rds_master_user_password}" \
    -e WORDPRESS_DB_NAME="${var.rds_database}" \
    wordpress:php7.3-apache 
EOF
}


output "word_press_ip" {
  value = aws_instance.wordpress.public_ip
}
