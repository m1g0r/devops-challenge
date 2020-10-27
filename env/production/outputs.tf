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
