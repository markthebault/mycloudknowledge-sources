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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| build\_role\_arn | the role to use when running codebuild | string | n/a | yes |
| buildspec | buildspec file to describe the build process | string | n/a | yes |
| codebuild\_container\_image | Container image to use with codebuild | string | n/a | yes |
| codebuild\_container\_type | Container type to use with codebuild | string | n/a | yes |
| container\_tag\_latest | The tag the container should have for describing the latest version | string | n/a | yes |
| names | List of builder' names | list | n/a | yes |
| repositories\_url | List of the repositories where the container will be push, the repositories need to be in the same order as the names | list | n/a | yes |
| tags | tags that will be used to create the resources | map | n/a | yes |
| timeout | Timeout for building | string | `"60"` | no |

## Outputs

| Name | Description |
|------|-------------|
| codebuild\_names | List of names of the different codebuild builders |

