data "aws_iam_policy_document" "wp_bucket_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [module.wp_s3_iam.this_iam_user_arn]
    }

    actions = [
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::${var.wp-s3["name"]}",
      "arn:aws:s3:::${var.wp-s3["name"]}/*",
    ]
  }
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${var.wp-s3["name"]}/*",
    ]
  }
}

module "wp_static_resources_s3" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "1.15.0"
  bucket  = var.wp-s3["name"]
  acl     = var.wp-s3["acl"]

  attach_policy = true
  policy        = data.aws_iam_policy_document.wp_bucket_policy.json

  tags = {
    "Terraform"   = "true"
    "Environment" = "prod"
    "Application" = "Wordpress"
  }
}
