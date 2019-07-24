output "codebuild_names" {
  value = "${aws_codebuild_project.dev.*.name}"
  description = "List of names of the different codebuild builders "
}