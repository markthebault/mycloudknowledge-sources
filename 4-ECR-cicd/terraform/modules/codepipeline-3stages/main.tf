/**
# mthcorp application module
This module defines a codecommit pipeline with 3 stages, the first stage is to checkout the repository,
the second stage is to build according to the definition of the builder and 
the third stage need a manual approval to execute the last builder.

## Usage
```
module "prod_pipeline" {
  source = "../../modules/codepipeline-3stages"

  names                           = "${formatlist("prod-pipelines-%s", var.repositories_names)}"
  codecommit_repo_names           = "${aws_codecommit_repository.repo.*.repository_name}"
  codebuild_builders_names_stage2 = "${module.prod_build.codebuild_names}"
  codebuild_builders_names_stage3 = "${module.prod_push.codebuild_names}"
  s3_pipeline_bucket              = "${aws_s3_bucket.pipeline.bucket}"
  pipeline_role_arn               = "${aws_iam_role.codepipeline.arn}"
  branch_name                     = "${lookup(local.git_source_branche_env, "prod")}"
}
```

*/
resource "aws_codepipeline" "pipeline" {
  count = "${length(var.names)}"

  name     = "${element(var.names, count.index)}"
  role_arn = "${var.pipeline_role_arn}"

  artifact_store {
    location = "${var.s3_pipeline_bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_ok"]

      configuration = {
        RepositoryName       = "${element(var.codecommit_repo_names, count.index)}"
        PollForSourceChanges = "true"
        BranchName           = "${var.branch_name}"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source_ok"]

      configuration = {
        ProjectName = "${element(var.codebuild_builders_names_stage2, count.index)}"
      }
    }
  }

  stage {
    name = "DeployProd"

    action {
      name      = "ApprovalStage"
      category  = "Approval"
      owner     = "AWS"
      provider  = "Manual"
      run_order = 1
      version   = "1"
    }

    action {
      name            = "Deploy"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_ok"]
      run_order       = 2
      version         = "1"

      configuration = {
        ProjectName = "${element(var.codebuild_builders_names_stage3, count.index)}"
      }
    }
  }

  #tags = "${merge(var.tags)}"
}
