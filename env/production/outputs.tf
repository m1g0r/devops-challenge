output "region" {
  description = "AWS region"
  value       = var.aws_region
}

output "VPC_info" {
  description = "VPC Info"
  value       = module.wp-vpc.vpc_id
}

output "RDS_cluster_endpoint" {
  description = "RDS cluster endpoint"
  value       = module.wp-rds.this_rds_cluster_endpoint
}

output "RDS_cluster_master_user" {
  description = "RDS cluster master user"
  value       = module.wp-rds.this_rds_cluster_master_username
}

output "RDS_cluster_master_password" {
  description = "RDS cluster master password"
  value       = module.wp-rds.this_rds_cluster_master_password
}

output "WP_s3_bucket" {
  description = "WP S3 bucket name"
  value       = module.wp_static_resources_s3.this_s3_bucket_bucket_domain_name
}

output "WP_S3_IAM_KEY" {
  description = "AWS Key for WP S3 IAM user"
  value       = module.wp_s3_iam.this_iam_access_key_id
}

output "WP_S3_IAM_SECRET" {
  description = "AWS Secret for WP S3 IAM user"
  value       = module.wp_s3_iam.this_iam_access_key_secret
}

output "WP_ALB_DNS" {
  description = "AWS ALB DNS name"
  value       = aws_alb.wordpress.dns_name
}
