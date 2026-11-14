# AWS services

## Application Load Balancer (ALB)
Layer 7 load balancer that accepts HTTP/HTTPS requests and routes them according to listener rules to a Target Group. It provides a stable DNS endpoint and integrates with target health checks.

## Target Group
Contains registered targets and health-check configuration. Targets marked unhealthy are not selected for normal new-request routing.

## EC2 Auto Scaling Group
Maintains a fleet of EC2 instances within configured minimum, desired, and maximum capacity. It can replace unhealthy instances and adjust capacity when a scaling policy is configured.

## Launch Template
Defines instance launch settings such as AMI, instance type, security groups, storage mappings, and user data. Versioning supports controlled configuration changes.

## Amazon Machine Image (AMI)
A reusable machine image used to launch EC2 instances with a consistent base operating system and preconfigured software.

## EBS
Persistent block storage for EC2. EBS volumes are Availability-Zone scoped and have lifecycle and attachment considerations.

## EBS snapshots
Point-in-time backups of EBS volumes. Snapshot creation does not automatically prove application consistency or a successful restore; recovery should be tested.

## VPC, subnets, and Internet Gateway
The VPC provides the network boundary, subnets place resources into Availability Zones, and an Internet Gateway provides internet routing for eligible public subnet resources.

## CloudWatch
Collects metrics and can trigger alarms and scaling policies. Useful metrics include CPU utilization, ALB request count per target, target response time, HTTP 5xx errors, and unhealthy host count.
