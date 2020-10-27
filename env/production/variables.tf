variable "aws_region" {
  description = "The default AWS region to create resources"
  default = "eu-central-1"
}

variable "wp-vpc" {
  description = "VPC WP config"
  type = map(string)
}
