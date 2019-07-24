resource "aws_iam_role" "codepipeline" {
  name = "codepipeline-algos-codebuild-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "codepipeline.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "exec_attach_pipeline" {
  role = "${aws_iam_role.codepipeline.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipelineFullAccess"
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline-algos-codebuild-role"
  role = "${aws_iam_role.codepipeline.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "codecommit:GitPull",
        "codecommit:Get*",
        "codecommit:UploadArchive"
      ],
      "Resource": "*"
    },
    {
      "Effect":"Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
          "${aws_s3_bucket.pipeline.arn}", 
          "${aws_s3_bucket.pipeline.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

module "prod_pipeline" {
  source = "./modules/codepipeline-3stages"

  names                           = "${formatlist("prod-pipelines-%s", list(local.repository_name))}"
  codecommit_repo_names           = "${list(aws_codecommit_repository.repo.repository_name)}"
  codebuild_builders_names_stage2 = "${module.build.codebuild_names}"
  codebuild_builders_names_stage3 = "${module.push.codebuild_names}"
  s3_pipeline_bucket              = "${aws_s3_bucket.pipeline.bucket}"
  pipeline_role_arn               = "${aws_iam_role.codepipeline.arn}"
  branch_name                     = "master"
  tags                            = "${merge(var.tags)}"
}
