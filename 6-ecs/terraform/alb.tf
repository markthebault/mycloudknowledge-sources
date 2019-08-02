
resource "aws_security_group" "alb" {
  name        = "allow_HTTP_from_internet"
  description = "Allow HTTP"
  vpc_id      = module.vpc.vpc_id

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


module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 4.0"

  load_balancer_name               = "wp-alb"
  security_groups                  = [aws_security_group.alb.id]
  logging_enabled                  = false
  subnets                          = module.vpc.public_subnets
  enable_cross_zone_load_balancing = true

  vpc_id = module.vpc.vpc_id
  # https_listeners          = "${list(map("certificate_arn", "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012", "port", 443))}"
  # https_listeners_count    = "1"
  http_tcp_listeners       = "${list(map("port", "${var.wordpress_port}", "protocol", "HTTP"))}"
  http_tcp_listeners_count = "1"
  target_groups            = "${list(map("name", "wp-tg", "backend_protocol", "HTTP", "backend_port", "${var.wordpress_port}", "health_check_matcher", "200-399", "slow_start", "60", "stickiness_enabled", "true", "cookie_duration", "3600", "target_type", "ip"))}"
  target_groups_count      = "1"

  tags = "${map("Environment", "dev")}"
}
