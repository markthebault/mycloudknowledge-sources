data "archive_file" "zip" {
  type = "zip"

  source {
    content  = file("Dockerrun.aws.json")
    filename = "Dockerrun.aws.json"
  }

  output_path = "./${var.application_name}-Dockerrun.zip"
}

resource "random_id" "rand" {
  byte_length = 4
}

resource "aws_s3_bucket" "default" {
  bucket        = "${var.application_name}-beanstalk-deployments-${random_id.rand.hex}"
  force_destroy = true
}

resource "aws_s3_bucket_object" "default" {
  bucket = "${aws_s3_bucket.default.id}"
  key    = "${var.application_name}-Dockerrun"
  source = "./${var.application_name}-Dockerrun.zip"
  etag   = "${data.archive_file.zip.output_md5}"
}

# Beanstalk Application
resource "aws_elastic_beanstalk_application" "default" {
  name        = "${var.application_name}"
  description = "${var.application_description}"
}

resource "aws_elastic_beanstalk_application_version" "default" {
  name        = "${var.application_name}-${var.application_version}"
  application = "${var.application_name}"
  description = "application version created by terraform"
  bucket      = "${aws_s3_bucket.default.id}"
  key         = "${aws_s3_bucket_object.default.id}"

  lifecycle {
    create_before_destroy = true
  }
}

# Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "default" {
  name                = "${var.application_name}-docker"
  application         = "${aws_elastic_beanstalk_application.default.name}"
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.12.14 running Docker 18.06.1-ce"
  version_label       = "${aws_elastic_beanstalk_application_version.default.name}"

  #   setting {
  #     namespace = "aws:autoscaling:launchconfiguration"
  #     name      = "InstanceType"

  #     value = "${var.instance_type}"
  #   }

  #   setting {
  #     namespace = "aws:autoscaling:asg"
  #     name      = "MaxSize"

  #     value = "${var.autoscaling_maxsize}"
  #   }

  #   setting {
  #     namespace = "aws:autoscaling:launchconfiguration"
  #     name      = "IamInstanceProfile"
  #     value     = "${aws_iam_instance_profile.ec2.name}"
  #   }

  #   setting {
  #     namespace = "aws:elasticbeanstalk:environment"
  #     name      = "ServiceRole"
  #     value     = "${aws_iam_role.service.name}"
  #   }

  #   setting {
  #     namespace = "aws:elasticbeanstalk:application"
  #     name      = "Application Healthcheck URL"
  #     value     = "${var.health_check}"
  #   }



  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = module.vpc.vpc_id
  }


  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "true"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", module.vpc.public_subnets)
  }



  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "WORDPRESS_DB_HOST"
    value     = module.db.this_db_instance_endpoint
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "WORDPRESS_DB_USER"
    value     = var.rds_master_user
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "WORDPRESS_DB_PASSWORD"
    value     = var.rds_master_user_password
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "WORDPRESS_DB_NAME"
    value     = var.rds_database
  }
}

output "cname" {
  value = "${aws_elastic_beanstalk_environment.default.cname}"
}
