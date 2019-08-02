resource "aws_ecs_cluster" "main" {
  name = "ecs-cluster"
}

resource "aws_ecs_task_definition" "wordpress" {
  family                   = "wordpress"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.fargate_cpu}"
  memory                   = "${var.fargate_memory}"

  container_definitions = <<DEFINITION
[
  {
    "cpu": ${var.fargate_cpu},
    "image": "${var.wordpress_image}",
    "memory": ${var.fargate_memory},
    "name": "wordpress",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${var.wordpress_port},
        "hostPort": ${var.wordpress_port}
      }
    ],
    "Environment": [
      {
        "Name": "WORDPRESS_DB_HOST",
        "Value": "mysql.ecs.local"
      },
      {
        "Name": "WORDPRESS_DB_USER",
        "Value": "wordpress"
      },
      {
        "Name": "WORDPRESS_DB_NAME",
        "Value": "wordpress"
      },
      {
        "Name": "WORDPRESS_DB_PASSWORD",
        "Value": "wordpress"
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "wordpress" {
  name = "ecs-wordpress"
  cluster = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.wordpress.arn}"
  desired_count = var.wordpress_counts
  launch_type = "FARGATE"

  network_configuration {
    security_groups = ["${aws_security_group.wordpress.id}"]
    subnets = module.vpc.private_subnets
  }

  load_balancer {
    target_group_arn = module.alb.target_group_arns[0]
    container_name = "wordpress"
    container_port = "${var.wordpress_port}"
  }

  service_registries {
    registry_arn = aws_service_discovery_service.wordpress.arn
  }

  depends_on = [
    "module.alb.target_group_arns",
  ]
}

resource "aws_security_group" "wordpress" {
  name = "allow_HTTP"
  description = "Allow HTTP"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
