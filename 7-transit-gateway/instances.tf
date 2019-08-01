resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

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


##################### VPC1
resource "aws_security_group" "sg_vm1" {
  name        = "sg_vm1"
  description = "Allow All inbound traffic"
  vpc_id      = "${module.vpc1.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "vm1" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.sg_vm1.id}"]
  subnet_id              = "${module.vpc1.public_subnets[0]}"
  key_name               = "${aws_key_pair.deployer.key_name}"

  tags = {
    Name = "HelloWorld1"
  }
}

##################### VPC2
resource "aws_security_group" "sg_vm2" {
  name        = "sg_vm2"
  description = "Allow All inbound traffic"
  vpc_id      = "${module.vpc2.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "vm2" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.sg_vm2.id}"]
  subnet_id              = "${module.vpc2.public_subnets[0]}"
  key_name               = "${aws_key_pair.deployer.key_name}"

  tags = {
    Name = "HelloWorld2"
  }
}


##################### VPC3
resource "aws_security_group" "sg_vm3" {
  name        = "sg_vm3"
  description = "Allow All inbound traffic"
  vpc_id      = "${module.vpc3.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "vm3" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.sg_vm3.id}"]
  subnet_id              = "${module.vpc3.public_subnets[0]}"
  key_name               = "${aws_key_pair.deployer.key_name}"

  tags = {
    Name = "HelloWorld3"
  }
}


##################### VPC4
resource "aws_security_group" "sg_vm4" {
  name        = "sg_vm4"
  description = "Allow All inbound traffic"
  vpc_id      = "${module.vpc4.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "vm4" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.sg_vm4.id}"]
  subnet_id              = "${module.vpc4.public_subnets[0]}"
  key_name               = "${aws_key_pair.deployer.key_name}"

  tags = {
    Name = "HelloWorld4"
  }
}
