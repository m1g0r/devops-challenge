module "wp_s3_iam" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user/"
  version = "2.22.0"
  name    = var.wp-s3-iam["name"]

  create_iam_user_login_profile = false
  create_iam_access_key         = true
}
