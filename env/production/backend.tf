terraform {
  backend "s3" {
    bucket = "wp.devchallenge.terraform"
    key    = "env/production/terraform.tfstate"
    region = "eu-central-1"

    encrypt = "true"
    acl = "private"
  }
}