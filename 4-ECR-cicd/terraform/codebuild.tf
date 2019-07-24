resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-build-algos-codebuild-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "codebuild.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "exec_attach" {
  role = "${aws_iam_role.codebuild_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"
}


resource "aws_iam_policy" "codebuild_policy" {
  name = "codebuild-build-algos-codebuild-policy"
  description = "Code build extra policies"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "codebuild:*",
      "Resource": ["*"]
    },
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "autoscaling:*",
        "codebuild:*",
        "ec2:*",
        "elasticloadbalancing:*",
        "iam:*",
        "logs:*",
        "rds:DescribeDBInstances",
        "route53:*",
        "s3:*",
        "ecr:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters",
        "ssm:PutParameter"
      ],
      "Resource": "arn:aws:ssm:::parameter/*"
    }
  ]
}
    POLICY
}
resource "aws_iam_policy_attachment" "codebuild_policy_attachment" {
  name       = "codebuild-policy-attachment"
  policy_arn = "${aws_iam_policy.codebuild_policy.arn}"
  roles      = ["${aws_iam_role.codebuild_role.id}"]
}



module "build" {
  source = "./modules/codebuild"

  names                     = "${formatlist("prod-code-build-%s", list(local.repository_name))}"
  repositories_url          = "${list(aws_ecr_repository.repo.repository_url)}"
  container_tag_latest      = "tmp" #should be something that is not used like 'tmp' for prod on stage 2
  buildspec                 = "${file("${path.module}/buildspecs/build-project.yml")}"
  build_role_arn            = "${aws_iam_role.codebuild_role.arn}"
  codebuild_container_type  = "${var.codebuild_container_type}"
  codebuild_container_image = "${var.codebuild_container_image}"
  tags                      = "${merge(var.tags)}"
}
module "push" {
  source = "./modules/codebuild"

  names                     = "${formatlist("prod-code-push-%s", list(local.repository_name))}"
  repositories_url          = "${list(aws_ecr_repository.repo.repository_url)}"
  container_tag_latest      = "latest"
  buildspec                 = "${file("${path.module}/buildspecs/deploy-prod.yml")}"
  build_role_arn            = "${aws_iam_role.codebuild_role.arn}"
  codebuild_container_type  = "${var.codebuild_container_type}"
  codebuild_container_image = "${var.codebuild_container_image}"
  tags                      = "${merge(var.tags)}"
}
