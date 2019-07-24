variable "names" {
  type        = "list"
  description = "List of builder' names"
}

variable "repositories_url" {
  type = "list"

  description = "List of the repositories where the container will be push, the repositories need to be in the same order as the names"
}

variable "container_tag_latest" {
  description = "The tag the container should have for describing the latest version"
}

variable "buildspec" {
  description = "buildspec file to describe the build process"
}

variable "build_role_arn" {
  description = "the role to use when running codebuild"
}

variable "codebuild_container_type" {
  description = "Container type to use with codebuild"
}

variable "codebuild_container_image" {
  description = "Container image to use with codebuild"
}
variable "tags" {
  type = "map"
  description = "tags that will be used to create the resources"
}
variable "timeout" {
  description = "Timeout for building"
  default     = 60
}