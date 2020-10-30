resource "aws_ecs_task_definition" "wordpress" {
  family = var.wp-app["name"]
  container_definitions = <<DEFINITION
[
  {
    "essential": true,
    "image": "wordpress:latest",
    "environment": [
      {
        "name": "WORDPRESS_DB_HOST",
        "value": "${module.wp-rds.this_rds_cluster_endpoint}"
      },
      {
        "name": "WORDPRESS_DB_USER",
        "value": "${module.wp-rds.this_rds_cluster_master_username}"
      },
      {
        "name": "WORDPRESS_DB_PASSWORD",
        "value": "${module.wp-rds.this_rds_cluster_master_password}"
      },
      {
        "name": "WORDPRESS_DB_NAME",
        "value": "wordpress"
      }
    ],
    "memory": 256,
    "name": "${var.wp-app["name"]}",
    "portMappings": [
      {
        "containerPort": ${var.wp-app["port"]}
      }
    ],
    "dockerLabels": {
        "name": "${var.wp-app["name"]}"
    },
    "logConfiguration": {
      "logDriver": "json-file"
    }
  }
]
DEFINITION
}

resource "aws_ecs_service" "wordpress" {
  name            = var.wp-app["name"]
  cluster         = module.ecs.this_ecs_cluster_id
  task_definition = aws_ecs_task_definition.wordpress.family
  desired_count   = var.wp-app["desired_count"]
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
  load_balancer {
    target_group_arn = aws_alb_target_group.wordpress.arn
    container_name   = var.wp-app["name"]
    container_port   = var.wp-app["port"]
  }
}

resource "aws_alb_target_group" "wordpress" {
  name                 = var.wp-app["name"]
  port                 = var.wp-app["port"]
  protocol             = "HTTP"
  vpc_id               = module.wp-vpc.vpc_id
  deregistration_delay = 30
  health_check {
    path               = "/"
    timeout            = 3
    matcher            = "200"
  }
}

resource "aws_alb" "wordpress" {
  name            = var.wp-app["name"]
  internal        = false
  subnets         = [module.wp-vpc.public_subnets[0],module.wp-vpc.public_subnets[1],module.wp-vpc.public_subnets[2]]
  security_groups = [aws_security_group.allow_all_http_https.id,aws_security_group.allow_traffic.id]
}

resource "aws_alb_listener" "wordpress-http" {
  load_balancer_arn = aws_alb.wordpress.arn
  port              = var.wp-app["port"]
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.wordpress.id
    type             = "forward"
  }
}
