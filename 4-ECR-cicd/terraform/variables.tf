variable "tags" {
  default = {
    Terraform = "true"
  }
}

variable "env" { default = "test" }

variable "aws_region" { default = "us-east-1" }

# variable "container_cpu" {
#   default = 1
# }

# variable "container_ram" {
#   default = 512
# }

variable "codebuild_container_type" {
  default     = "BUILD_GENERAL1_SMALL"
  description = "Instance type to build the projects"
}

variable "codebuild_container_image" {
  default     = "aws/codebuild/docker:18.09.0"
  description = "default docker image to build"
}
