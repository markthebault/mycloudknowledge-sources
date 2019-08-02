
resource "aws_ecs_task_definition" "mysql" {
  family                   = "mysql"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.fargate_cpu}"
  memory                   = "${var.fargate_memory}"

  container_definitions = <<DEFINITION
[
  {
    "cpu": ${var.fargate_cpu},
    "image": "${var.mysql_image}",
    "memory": ${var.fargate_memory},
    "name": "mysql",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${var.mysql_port},
        "hostPort": ${var.mysql_port}
      }
    ],
    "Environment": [
      {
        "Name": "MYSQL_DATABASE",
        "Value": "wordpress"
      },
      {
        "Name": "MYSQL_USER",
        "Value": "wordpress"
      },
      {
        "Name": "MYSQL_ROOT_PASSWORD",
        "Value": "Master123!"
      },
      {
        "Name": "MYSQL_PASSWORD",
        "Value": "wordpress"
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "mysql" {
  name = "ecs-mysql"
  cluster = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.mysql.arn}"
  desired_count = 1
  launch_type = "FARGATE"

  network_configuration {
    security_groups = ["${aws_security_group.mysql.id}"]
    subnets = module.vpc.private_subnets
  }

  #   load_balancer {
  #     target_group_arn = module.alb.target_group_arns[0]
  #     container_name = "mysql"
  #     container_port = "${var.mysql_port}"
  #   }

  service_registries {
    registry_arn = aws_service_discovery_service.mysql.arn
  }

  depends_on = [
    "module.alb.target_group_arns",
  ]
}

resource "aws_security_group" "mysql" {
  name = "allow_mysql"
  description = "Allow mysql"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port = 3306
    to_port = 3306
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
