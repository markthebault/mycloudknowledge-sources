data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/id_rsa.pub")
}



resource "aws_instance" "instance_vpc" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "t2.micro"
  subnet_id              = "${module.aws_vpc.public_subnets[0]}"
  vpc_security_group_ids = ["${aws_security_group.aws_instance.id}"]
  key_name               = "${aws_key_pair.deployer.id}"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

output "aws_instance_public_ip" {
  value = aws_instance.instance_vpc.public_ip
}
output "aws_instance_private_ip" {
  value = aws_instance.instance_vpc.private_ip
}


resource "aws_security_group" "aws_instance" {
  name        = "open-instance-sg"
  description = "Allow traffric form GCP and ssh from everywhere"
  vpc_id      = "${module.aws_vpc.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
