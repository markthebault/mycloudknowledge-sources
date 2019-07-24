locals {
  sg_tags = {
    Application = "ECS Task"
  }

  repository_name = "my-first-cicd"
}


resource "aws_codecommit_repository" "repo" {
  repository_name = "${local.repository_name}"
  default_branch  = "master"
}

resource "aws_ecr_repository" "repo" {
  name = "${local.repository_name}"
}

resource "aws_s3_bucket" "pipeline" {
  bucket        = "${local.repository_name}-cicd-pipeline-bucket"
  acl           = "private"
  force_destroy = true
}




