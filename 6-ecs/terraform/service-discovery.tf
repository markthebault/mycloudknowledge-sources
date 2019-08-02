resource "aws_service_discovery_private_dns_namespace" "ecs" {
  name        = "ecs.local"
  description = "example"
  vpc         = module.vpc.vpc_id
}

resource "aws_service_discovery_service" "mysql" {
  name = "mysql"

  dns_config {
    namespace_id = "${aws_service_discovery_private_dns_namespace.ecs.id}"

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_service" "wordpress" {
  name = "wordpress"

  dns_config {
    namespace_id = "${aws_service_discovery_private_dns_namespace.ecs.id}"

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}
