# DevOps | DEV Challenge XVII
## Owerview
In this document, I would like to describe the Core components to building a high-available, scalable, fault tolerance, and secure infrastructure on AWS Cloud for WordPress using the best approaches and practices.

## Requirements

| Name | Version |
|------|---------|
| [terraform](https://www.terraform.io/) | = 0.12.29 |
| [AWS](https://registry.terraform.io/providers/hashicorp/aws/latest) | = 3.9.0 |
| [random](https://registry.terraform.io/providers/hashicorp/random/latest) | ~> 2.2 |

## Terraform modules

| Name | Version |
|------|:-------:|
| [VPC](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest) | 2.6.0 |
| [RDS](https://registry.terraform.io/modules/terraform-aws-modules/rds-aurora/aws/latest) | 2.28.0 |
| [S3 bucket](https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/latest) | 1.15.0 |
| [IAM](https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest) | 2.22.0 |
| [ECS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | 2.4.0 |

## Outputs

| Name | Description |
|------|-------------|
| AWS region | AWS Region |
| VPC id | AWS VPC id |
| RDS cluster endpoint | The cluster endpoint to connect |
| RDS cluster username | The RDS cluster username to connect |
| RDS cluster password | The RDS cluster password to connect |
| AWS S3 bucket | AWS S3 bucket for static resources |
| AWS IAM KEY | AWS IAM KEY for access to S3 bucket for static resources |
| AWS IAM SECRET | AWS IAM SECRET for access to S3 bucket for static resources |
| AWS ALB DNS name | AWS ALB DNS record  / WordPress host |

## Detailed design
![AWS Infrastructure](img/infrastructure.png?raw=true "Title")

## Notes
[WordPress reader](https://pantheon.io/docs/hyperdb)
[WordPress CDN and S3](https://blog.lawrencemcdaniel.com/integrating-aws-s3-cloudfront-with-wordpress-2/)

