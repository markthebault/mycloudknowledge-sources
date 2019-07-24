variable "names" {
  type        = "list"
  description = "List of pipeline names"
}

variable "codecommit_repo_names" {
  type        = "list"
  description = "List of the repos, must be in the same order as the names"
}

variable "codebuild_builders_names_stage2" {
  type        = "list"
  description = "List of the codebuild builder that will be used in stage2, should be as the same order as the names"
}

variable "codebuild_builders_names_stage3" {
  type        = "list"
  description = "List of the codebuild builder that will be used in stage3, should be as the same order as the names"
}

variable "s3_pipeline_bucket" {
  description = "s3 bucket that will be used to store the results of the pipeline"
}
variable "tags" {
  type = "map"
  description = "tags that will be used to create the resources"
  default = {}
}

variable "pipeline_role_arn" {
  description = "Role that should use the pipeline"
}

variable "branch_name" {
  description = "Branch of the git repository that should be used"
}
