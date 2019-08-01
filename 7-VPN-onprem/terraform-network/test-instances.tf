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


resource "aws_instance" "instance_vpc1" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "t2.micro"
  subnet_id              = "${module.vpc_1.public_subnets[0]}"
  vpc_security_group_ids = ["${aws_security_group.vpc1_test_instance.id}"]
  key_name               = "${aws_key_pair.mth_kp.id}"

  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
  }
}

resource "aws_instance" "instance_vpc2" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "t2.micro"
  subnet_id              = "${module.vpc_2.public_subnets[0]}"
  vpc_security_group_ids = ["${aws_security_group.vpc2_test_instance.id}"]
  key_name               = "${aws_key_pair.mth_kp.id}"

  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
  }
}



resource "aws_security_group" "vpc1_test_instance" {
  name        = "open-instance-sg"
  description = "Allow ssh traffic from certain IP range to vyos_instance on port 22"
  vpc_id      = "${module.vpc_1.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "vpc2_test_instance" {
  name        = "open-instance-sg"
  description = "Allow ssh traffic from certain IP range to vyos_instance on port 22"
  vpc_id      = "${module.vpc_2.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
