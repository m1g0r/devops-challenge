variable "aws_region" {
  description = "The default AWS region to create resources"
  default = "eu-central-1"
}

variable "wp-vpc" {
  description = "VPC WP config"
  type = map(string)
}

variable "wp-s3" {
  description = "S3 config for WP"
  type = map(string)
}

variable "wp-s3-iam" {
  description = "IAM user for S3"
  type = map(string)
}

variable "wp-ecs-config" {
  description = "Configmap for ECS cluster"
  type = map(string)
}
