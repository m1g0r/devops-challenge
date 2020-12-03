# DevOps | DEV Challenge XVII
## Owerview
In this document, I would like to describe the Core components to building a high-available, scalable, fault tolerance, and secure infrastructure on AWS Cloud for WordPress using the best approaches and practices.

## Proposal
### Infrastructure as Code
Infrastructure as Code has emerged as a best practice for automating the provisioning of infrastructure services. For this purpose, I suggest using the Terraform CLI. Terraform is an open source provisioning tool from HashiCorp (more information at http://terraform.io​ ). It is used for building, changing and versioning infrastructure, safely and efficiently. Terraform will manage the state of our environment on AWS. That means, if something is not in conformity, it will try to fix keeping as close as possible to the desired state.

### Infrastructure Core components:
#### AWS ECS
As we are going to make our environment secure, scalable, and high available, we’ve
chosen ​ AWS Elastic Container Service​ (ECS) as a docker orchestration system. The ECS cluster should be built on the basis of an autoscaling group that will allow a flexible response (horizontal scale wordpress service and EC2 instances in the cluster) to loads during peaks and save resources when the load is small. Also, in this case, our site will be hosted in multiple instances on multiple servers that are hosted in different availability zones. This approach minimizes the risk of our service becoming inaccessible to our castomers.
##### Benefits:
- Easy scalability and infrastructure management
- AWS Fargate support (a serverless compute engine for containers)
- AWS Elastic Load Balancing support

#### MySQL Databases
As a relational database for WordPress, I recommend to usage ​ Amazon Aurora​ . It is a MySQL-compatible relational database built for the cloud, that combines the performance and availability of traditional enterprise databases with the simplicity and cost-effectiveness of open source databases. If you use a replica, we guarantee stable access to our service to the database. In case of unavailability of the main server, the replica automatically takes over the responsibilities of the master and we do not lose information and continue to serve our users. It is also possible to make our service more accessible at high loads by using a replica reader. Out of the box, WordPress does not have such functionality, but after [installing the plugin and additional settings](https://pantheon.io/docs/hyperdb), everything should work. In this example, the replicas are automatically scaled as the load on CPU is increased (replica_scale_cpu = 80).
##### Benefits:
- Automated Backups
- Offers managed updates
- No hardware maintenance needed
- Simplified scaling in comparison to on-premise databases
- Simplified disaster recovery and automatic failover
- Automated additional storage allocation

#### Amazon Simple Storage Service (Amazon S3)
For store WordPress static resources we can usage Amazon S3 bucket. Is an object storage service that offers industry-leading scalability, data availability, security, and performance. Using an AWS S3 bucket will allow you to transfer the load on the return of static resources from the server to the AWS S3 bucket side. Also, we will have an opportunity to scale our WordPress in several copies without problems with display of images on a site as all copies will have one data source. To integrate AWS 3S bucket to WordPress we can use [WordPress plugin](https://wordpress.org/plugins/amazon-s3-and-cloudfront/)
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

## Automate Terraform with GitHub Actions
GitHub Actions add continuous integration to GitHub repositories to automate your software builds, tests, and deployments. Automating Terraform with CI/CD enforces configuration best practices, promotes collaboration and automates the Terraform workflow.

HashiCorp's "Setup Terraform" GitHub Action sets up and configures the Terraform CLI in your Github Actions workflow. This allows most Terraform commands to work exactly like they do on your local command line.

![workspace](img/gh-actions-workflow.png?raw=true "Title")
The workflow will:

- Check whether the configuration is formatted properly to demonstrate how you can enforce best practices
- Generate a plan for every pull requests
- Apply the configuration

Then, we will create and merge a pull request to test the workflow. After merge pull requests test infrastructure should be deleted. After than GitHub Action should apply new configuration from the main branch.

Terraform Cloud's built-in support for GitHub webhooks can accomplish this generic workflow. By performing the run from an Actions workflow, we can customize the workflow by adding additional steps before or after our Terraform commands.

## How to start
### Set up your AWS account
When you first register for AWS, you initially sign in as the root user. This user account has access permissions to everything, so from a security perspective, I recommend only using it to create other user accounts with more limited permissions. You should create a separate user for terraform (Programmatic access), grant permissions, and enables an access key ID and secret access key.

### Set up your Terraform Cloud account
The GitHub Action you create will connect to Terraform Cloud to plan and apply your configuration. Before we set up the Actions workflow, you must create a workspace, add your AWS service credentials to your Terraform Cloud workspace, and generate a user API token.

First, create a new Terraform Cloud workspace
Go to the [Create a new Workspace](https://app.terraform.io/app/edubot/workspaces/new) page and select "API-driven workflow". Name your workspace "DevOps-DEV-Challenge-XVII" and click "Create workspace".
![workspace](img/workspace.png?raw=true "Title")

Next, add the following as Environment Variables for your gh-actions-demo workspace with their respective values from the access credentials file you downloaded from AWS earlier.
```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```
Mark both of these values as sensitive. Terraform Cloud will use these credentials to authenticate to AWS. You will see something similar to the image below.
![workspace](img/aws-sec.png?raw=true "Title")

Finally, go to the [Tokens page](https://app.terraform.io/app/settings/tokens) in your Terraform Cloud User Settings. Click on "Create an API token" and generate an API token named GitHub Actions.

Save this token in a safe place. You will add it to GitHub later as a secret, so the Actions workflow can authenticate to Terraform Cloud.
![workspace](img/generate-tfc-user-token.gif?raw=true "Title")

### Set up a GitHub repository
Navigate to "Settings" then "Secrets". Create a new secret named TF_API_TOKEN, setting the Terraform Cloud API token you created in the previous step as the value.
![GitHub](img/git.png?raw=true "Title")

### GitHub Actions workflow
These steps define all actions in the workflow. However, this job does not run every step when you trigger the action. Some of these steps only run from pull requests; others only run only when you merge a commit to master.

![gh](img/actions-workflow.png?raw=true "Title")

Tip: In a production environment, consider adding "Require status checks to pass before merging" as a Branch Protection rule. This adds another layer of protection, ensuring that this workflow successfully completes before changes are merged into master.
### Create pull request
[GitHub Pull Request](https://github.com/m1g0r/devops-challenge/pulls)
![pr](img/pr.png?raw=true "Title")

### Terraform outputs

| Name | Description |
|------|-------------|
| AWS region | AWS Region |
| VPC id | AWS VPC id |
| RDS cluster endpoint | The cluster endpoint to connect |
| RDS cluster username | The RDS cluster username |
| RDS cluster password | The RDS cluster password |
| AWS S3 bucket | AWS S3 bucket for static resources |
| AWS IAM KEY | AWS IAM KEY for access to S3 bucket for static resources (for WordPress plugin) |
| AWS IAM SECRET | AWS IAM SECRET for access to S3 bucket for static resources (for WordPress plugin) |
| AWS ALB DNS name | AWS ALB DNS record  / WordPress host |

### Terraform outputs after apply
![Terraform output](img/output.jpg?raw=true "Title")

### WordPress database settings
All database connection parameters (host, username, password, database name) are automatically inserted into [aws_ecs_task_definition](env/production/wordpress.tf) through the docker environment variables

### WordPress site after apply (available by ALB DNS name after apply)
![WordPress](img/wp.jpg?raw=true "Title")
