terraform {
  backend "remote" {
    organization = "WP-production"

    workspaces {
      name = "DevOps-DEV-Challenge-XVII"
    }
  }
}
