module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "2.4.0"
  name    = var.wp-ecs-config["name"]
}

module "ec2_profile" {
  source = "terraform-aws-modules/ecs/aws//modules/ecs-instance-profile"
  name   = var.wp-ecs-config["name"]
}

data "aws_ami" "amazon_linux_ecs" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

module "this" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = var.wp-ecs-config["name"]

  # Launch configuration
  lc_name = var.wp-ecs-config["name"]

  image_id             = data.aws_ami.amazon_linux_ecs.id
  instance_type        = "t2.micro"
  security_groups      = [aws_security_group.allow_traffic.id]
  iam_instance_profile = module.ec2_profile.this_iam_instance_profile_id
  user_data            = data.template_file.user_data.rendered

  # Auto scaling group
  asg_name                  =   var.wp-ecs-config["name"]
  vpc_zone_identifier       = module.wp-vpc.private_subnets
  health_check_type         = "EC2"
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "Environment"
      value               = "prod"
      propagate_at_launch = true
    },
    {
      key                 = "Cluster"
      value               = var.wp-ecs-config["name"]
      propagate_at_launch = true
    },
  ]
}

data "template_file" "user_data" {
  template = file("templates/user-data.sh")

  vars = {
    cluster_name = var.wp-ecs-config["name"]
  }
}
