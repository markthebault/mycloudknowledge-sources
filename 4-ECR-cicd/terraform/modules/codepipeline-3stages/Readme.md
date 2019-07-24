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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| branch\_name | Branch of the git repository that should be used | string | n/a | yes |
| codebuild\_builders\_names\_stage2 | List of the codebuild builder that will be used in stage2, should be as the same order as the names | list | n/a | yes |
| codebuild\_builders\_names\_stage3 | List of the codebuild builder that will be used in stage3, should be as the same order as the names | list | n/a | yes |
| codecommit\_repo\_names | List of the repos, must be in the same order as the names | list | n/a | yes |
| names | List of pipeline names | list | n/a | yes |
| pipeline\_role\_arn | Role that should use the pipeline | string | n/a | yes |
| s3\_pipeline\_bucket | s3 bucket that will be used to store the results of the pipeline | string | n/a | yes |
| tags | tags that will be used to create the resources | map | `<map>` | no |

