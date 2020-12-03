wp-vpc = {
  "name" = "wp-vpc"
  "cidr" = "10.0.0.0/16"
}

wp-s3 = {
  "name" = "wp-static-resources"
  "acl"  = "private"
}

wp-s3-iam = {
  "name" = "wp-s3"
}

wp-ecs-config = {
  "name" = "wp"
}

wp-app = {
  "name"          = "wordpress"
  "port"          = 80
  "desired_count" = 1
}
