# Terraform reference implementation

This directory is a **separate IaC implementation** of the architecture. It is not a record of how the original console-based environment was created.

## What it provisions

- VPC with two public subnets across two AZs.
- Internet Gateway and public route table.
- ALB security group and instance security group.
- Internet-facing Application Load Balancer.
- HTTP listener and Target Group.
- Launch Template using the latest Amazon Linux 2023 AMI.
- EC2 Auto Scaling Group with min 2, desired 2, max 3.
- CPU target-tracking scaling policy.

## Before running

1. Install Terraform and configure AWS credentials using a secure local method such as an AWS profile.
2. Review `variables.tf` and `terraform.tfvars.example`.
3. Review every resource and the expected cost in your AWS region.
4. Run `terraform fmt -recursive`, `terraform init`, `terraform validate`, and `terraform plan`.
5. Only run `terraform apply` if you understand and approve the plan.

The example uses public subnets to keep the lab topology simple and avoid NAT Gateway charges. Instances do not receive public IP addresses and their inbound application port is restricted to the ALB security group. This is not a complete production network pattern. For production, use private application subnets with an intentional egress design.

The user-data script attempts to start nginx if it is already installed. It does not install packages because the private instances have no configured outbound internet route. For a working demo page, bake nginx and the page into a custom AMI, or design a secure package/bootstrap path before deployment.

## State and secrets

- Never commit `terraform.tfstate`, `.terraform/`, credentials, or a real `terraform.tfvars`.
- The included `.gitignore` excludes local state and variable files.
- Configure a remote backend separately before team use. The example backend notes are in `backend.example.tf`.
- S3 backend bucket creation and state locking configuration are intentionally not automated here.

## Cleanup

Run `terraform destroy` only when you intend to remove all resources managed by this state.
