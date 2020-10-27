output "region" {
  description = "AWS region"
  value       = var.aws_region
}

output "VPC_info" {
  description = "VPC Info"
  value       = module.wp-vpc.vpc_id
}
