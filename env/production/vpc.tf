module "wp-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.6.0"

  name                 = var.wp-vpc["name"]
  cidr                 = var.wp-vpc["cidr"]
  azs                  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "Terraform"   = "true"
    "Environment" = "prod"
    "Application" = "Wordpress"
  }

  public_subnet_tags = {
    "Terraform"   = "true"
    "Environment" = "prod"
    "Application" = "Wordpress"
  }

  private_subnet_tags = {
    "Terraform"   = "true"
    "Environment" = "prod"
    "Application" = "Wordpress"
  }
}
