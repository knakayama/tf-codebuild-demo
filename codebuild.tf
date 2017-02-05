resource "aws_codebuild_project" "codebuild" {
  name         = "${var.env}-project"
  service_role = "${aws_iam_role.codebuild.arn}"
  timeout      = 60

  artifacts {
    type     = "S3"
    location = "${random_id.s3.hex}"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/nodejs:7.0.0"
    type         = "LINUX_CONTAINER"

    environment_variable = {
      "name"  = "S3"
      "value" = "${random_id.s3.hex}"
    }

    environment_variable = {
      "name"  = "STAGE"
      "value" = "${var.codebuild_config["stage"]}"
    }
  }

  source {
    type     = "GITHUB"
    location = "${var.codebuild_config["source_location"]}"

    # not work
    #auth = {
    #  type = "OAUTH"
    #}
  }

  tags {
    "Environment" = "${var.env}-project"
  }
}
