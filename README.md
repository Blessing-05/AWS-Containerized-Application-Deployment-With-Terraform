# AWS Containerized Application Deployment with Terraform

## Project Overview

This project demonstrates the deployment of a containerized Node.js application on AWS using Docker, Amazon ECS Fargate, Amazon ECR, and Terraform.

The infrastructure is provisioned using Terraform, following a multi-AZ VPC architecture that separates public-facing resources from private application workloads.

The application is deployed as Docker containers running on ECS Fargate, with an Application Load Balancer distributing incoming traffic across tasks in private subnets.

## Architecture

```text
                  Internet
                     |
                     v
          Application Load Balancer
                (Public Subnets)
                     |
              Target Group
                     |
          +----------+----------+
          |                     |
          v                     v
     ECS Fargate Task      ECS Fargate Task
     (Private Subnet 1)    (Private Subnet 2)
          |                     |
          +----------+----------+
                     |
              Outbound Traffic
                     |
                NAT Gateway
                     |
          +----------+----------+
          |                     |
          v                     v
       Amazon ECR          CloudWatch Logs
```

## AWS Services Used

| Service | Purpose |
|---|---|
| Amazon VPC | Provides isolated cloud networking |
| Public & Private Subnets | Separates internet-facing and application resources |
| Internet Gateway | Enables internet connectivity for public subnets |
| NAT Gateway | Provides outbound internet access to private subnets |
| Security Groups | Controls inbound and outbound traffic |
| Application Load Balancer | Distributes incoming application traffic |
| Amazon ECS | Orchestrates containerized workloads |
| AWS Fargate | Runs containers without managing servers |
| Amazon ECR | Stores Docker container images |
| AWS IAM | Provides permissions for ECS task execution |
| Amazon CloudWatch | Collects and stores application logs |
| Amazon S3 | Provides encrypted private object storage |
| Terraform | Automates AWS infrastructure provisioning |

## Application Details

The application is built using Node.js and Express.

It exposes two HTTP endpoints:

- `/` - Returns a welcome message and application information.
- `/health` - Returns the application's health status and uptime.

**Application Port:** 3000

## Project Structure

```text
aws-cloud-project/
│
├── application/
│   ├── app.js
│   ├── package.json
│   └── Dockerfile
│
└── terraform/
    ├── provider.tf
    ├── vpc.tf
    ├── security-groups.tf
    ├── ecr.tf
    ├── iam.tf
    ├── cloudwatch.tf
    ├── alb.tf
    ├── ecs.tf
    └── s3.tf
```

## Deployment Workflow

1. Develop the Node.js application.
2. Build and test the Docker image locally.
3. Initialize and validate the Terraform configuration.
4. Provision the AWS infrastructure using Terraform.
5. Authenticate Docker with Amazon ECR.
6. Build, tag, and push the container image to ECR.
7. Deploy the application using Amazon ECS Fargate.
8. Configure the Application Load Balancer to distribute traffic.
9. Verify application health and inspect logs in CloudWatch.

## Security Considerations

- ECS tasks run in private subnets without public IP addresses.
- Security groups restrict application traffic to the Application Load Balancer.
- IAM execution roles provide the permissions required for image retrieval and logging.
- S3 public access is blocked.
- S3 server-side encryption is enabled.
- ECR image scanning is enabled on image push.

## Testing

After deployment, retrieve the Application Load Balancer DNS name and test the endpoints:

```bash
curl http://<ALB-DNS-NAME>/
```

```bash
curl http://<ALB-DNS-NAME>/health
```

Application logs can be inspected through Amazon CloudWatch under:

`/ecs/project-app`

## Infrastructure Cleanup

To avoid unnecessary AWS charges, destroy the provisioned infrastructure when testing is complete.

Empty the S3 bucket and ECR repository before running:

```bash
terraform destroy
```

**Note:** NAT Gateway and Application Load Balancer resources can incur charges while running.

## Technologies

- AWS
- Terraform
- Docker
- Node.js
- Express.js
- Amazon ECS Fargate
- Amazon ECR
- Application Load Balancer
- Amazon VPC
- AWS IAM
- Amazon CloudWatch
- Amazon S3

## Project Objective

The objective of this project is to develop practical cloud engineering skills in infrastructure as code, containerization, AWS networking, container orchestration, IAM, load balancing, and cloud monitoring.

