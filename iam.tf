data "aws_iam_policy_document" "codebuild_sts" {
  statement {
    sid     = "CodeBuildAssumeRolePolicy"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals = {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codebuild" {
  name               = "${var.env}-codebuild-role"
  assume_role_policy = "${data.aws_iam_policy_document.codebuild_sts.json}"
}

data "aws_iam_policy_document" "codebuild_policy" {
  statement {
    sid       = "CodeBuildCFnPolicy"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["cloudformation:*"]
  }
}

resource "aws_iam_role_policy" "codebuild" {
  name   = "${var.env}-codebuild-policy"
  role   = "${aws_iam_role.codebuild.id}"
  policy = "${data.aws_iam_policy_document.codebuild_policy.json}"
}

resource "aws_iam_policy_attachment" "codebuild_lambda" {
  name       = "${var.env}-AWSLambdaFullAccess"
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaFullAccess"
  roles      = ["${aws_iam_role.codebuild.name}"]
}

resource "aws_iam_policy_attachment" "codebuild_api_gateway" {
  name       = "${var.env}-AmazonAPIGatewayAdministrator"
  policy_arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator"
  roles      = ["${aws_iam_role.codebuild.name}"]
}

resource "aws_iam_policy_attachment" "codebuild_iam" {
  name       = "${var.env}-AmazonAPIGatewayAdministrator"
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
  roles      = ["${aws_iam_role.codebuild.name}"]
}
