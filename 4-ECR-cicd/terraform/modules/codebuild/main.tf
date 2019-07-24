/**
# mthcorp application module
This module create builder for pipelines

## Usage
```
module "build" {
  source = "../../modules/codebuild"
  
  names                     = "${formatlist("dev-code-build-%s", var.repositories_names)}"
  repositories_url          = "${var.docker_repositories_url}"
  container_tag_latest       = "latest"
  buildspec                 = "${file("${path.module}/buildspecs/build-project.yml")}"
  build_role_arn            = "${aws_iam_role.codebuild_role.arn}"
  codebuild_container_type  = "${var.codebuild_container_type}"
  codebuild_container_image = "${var.codebuild_container_image}"
}
```

*/

resource "aws_codebuild_project" "dev" {
  count = "${length(var.names)}"

  name          = "${element(var.names, count.index)}"
  description   = "Docker Container build"
  build_timeout = "${var.timeout}"
  service_role  = "${var.build_role_arn}"

  environment {
    compute_type    = "${var.codebuild_container_type}"
    image           = "${var.codebuild_container_image}"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "CONTAINER_REPOSITORY"
      value = "${element(var.repositories_url, count.index)}"
    }

    environment_variable {
      name  = "CONTAINER_LASTEST_TAG_VALUE"
      value = "${var.container_tag_latest}"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "${var.buildspec}"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  tags = "${merge(var.tags)}"
}


