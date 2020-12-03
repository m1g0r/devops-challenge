module "wp-rds" {
  source                              = "terraform-aws-modules/rds-aurora/aws"
  version                             = "2.28.0"
  name                                = "wp-rds"
  engine                              = "aurora-mysql"
  engine_version                      = "5.7.12"
  subnets                             = [module.wp-vpc.private_subnets[0], module.wp-vpc.private_subnets[1], module.wp-vpc.private_subnets[2]]
  vpc_id                              = module.wp-vpc.vpc_id
  replica_scale_enabled               = true
  replica_scale_cpu                   = 80
  replica_scale_min                   = 1
  replica_scale_max                   = 5
  instance_type                       = "db.t2.small"
  apply_immediately                   = true
  skip_final_snapshot                 = true
  db_parameter_group_name             = aws_db_parameter_group.aurora_db_57_parameter_group.id
  db_cluster_parameter_group_name     = aws_rds_cluster_parameter_group.aurora_57_cluster_parameter_group.id
  iam_database_authentication_enabled = false
  enabled_cloudwatch_logs_exports     = ["audit", "error", "slowquery"]
  username                            = "admin"
  vpc_security_group_ids              = [aws_security_group.allow_traffic.id]
}

resource "aws_db_parameter_group" "aurora_db_57_parameter_group" {
  name        = "wp-aurora-db-57-parameter-group"
  family      = "aurora-mysql5.7"
  description = "wp-aurora-db-57-parameter-group"
}

resource "aws_rds_cluster_parameter_group" "aurora_57_cluster_parameter_group" {
  name        = "wp-aurora-57-cluster-parameter-group"
  family      = "aurora-mysql5.7"
  description = "wp-aurora-57-cluster-parameter-group"
}
