resource "random_id" "s3" {
  byte_length = 8

  keepers = {
    random_s3_bucket_name = "${var.env}"
  }
}

data "aws_iam_policy_document" "s3" {
  statement {
    sid = "S3Policy"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${random_id.s3.hex}",
      "arn:aws:s3:::${random_id.s3.hex}/*",
    ]

    principals = {
      type        = "AWS"
      identifiers = ["${aws_iam_role.codebuild.arn}"]
    }
  }
}

resource "aws_s3_bucket" "s3" {
  bucket        = "${random_id.s3.hex}"
  acl           = "private"
  policy        = "${data.aws_iam_policy_document.s3.json}"
  force_destroy = true
}
