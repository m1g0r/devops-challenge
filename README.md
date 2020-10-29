# DevOps | DEV Challenge XVII
## Owerview
In this document, I would like to describe the Core components to building a high-available, scalable, fault tolerance, and secure infrastructure on AWS Cloud for WordPress using the best approaches and practices.

## Proposal
### Infrastructure as Code
Infrastructure as Code has emerged as a best practice for automating the provisioning of infrastructure services. For this purpose, I suggest using the Terraform CLI. Terraform is an open source provisioning tool from HashiCorp (more information at http://terraform.io​ ). It is used for building, changing and versioning infrastructure, safely and efficiently. Terraform will manage the state of our environment on AWS. That means, if something is not in conformity, it will try to fix keeping as close as possible to the desired state.

### Infrastructure Core components:
#### AWS ECS
As we are going to make our environment secure, scalable, and high available, we’ve
chosen ​ AWS Elastic Container Service​ (ECS) as a docker orchestration system. The ECS cluster should be built on the basis of an autoscaling group that will allow a flexible response (horizontal scale EC2 in cluster) to loads during peaks and save resources when the load is small.
##### Benefits:
- Easy scalability and infrastructure management
- AWS Fargate support (a serverless compute engine for containers)
- AWS Elastic Load Balancing support

#### MySQL Databases
As a relational database for WordPress, I recommend to usage ​ Amazon Aurora​ . It is a MySQL-compatible relational database built for the cloud, that combines the performance and availability of traditional enterprise databases with the simplicity and cost-effectiveness of open source databases.
##### Benefits:
- Automated Backups
- Offers managed updates
- No hardware maintenance needed
- Simplified scaling in comparison to on-premise databases
- Simplified disaster recovery and automatic failover
- Automated additional storage allocation

#### Amazon Simple Storage Service (Amazon S3)
For store WordPress static resources we can usage Amazon S3 bucket. Is an object storage service that offers industry-leading scalability, data availability, security, and performance.
##### Benefits:
- Industry-leading performance, scalability, availability, and durability
- Wide range of cost-effective storage classes
- Easily manage data and access controls
- Availability of plugins for integration with WordPress

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

## Detailed design
![AWS Infrastructure](img/infrastructure.png?raw=true "Title")

## How to start
### Set up your AWS account
When you first register for AWS, you initially sign in as the root user. This user account has access permissions to everything, so from a security perspective, I recommend only using it to create other user accounts with more limited permissions. You should create a separate user for terraform (Programmatic access), grant permissions, and enables an access key ID and secret access key.
```
export AWS_ACCESS_KEY_ID=(your access key id)
export AWS_SECRET_ACCESS_KEY=(your secret access key)
```

### Build environment with terraform
The "terraform init" command is used to initialize a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control.
```
cd env/production
```
```
terraform init
```
```
terraform apply
```

### Terraform outputs

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

## Notes
[WordPress reader](https://pantheon.io/docs/hyperdb)
[WordPress CDN and S3](https://blog.lawrencemcdaniel.com/integrating-aws-s3-cloudfront-with-wordpress-2/)
