# Highly Available AWS Web Application Infrastructure

A portfolio case study for designing an AWS web application platform around an Application Load Balancer (ALB), EC2 Auto Scaling Group (ASG), Launch Template, AMI, EBS volumes, and EBS snapshots.

> **Implementation honesty:** The original hands-on build was performed through the AWS Management Console. The `terraform/` directory is a separate reference implementation scaffold for recreating the architecture as Infrastructure as Code. Do not describe the Terraform version as deployed until you have actually applied and tested it.

## Project at a glance

| Area | Design |
|---|---|
| Primary objective | Reduce dependence on a single EC2 instance |
| Entry point | Internet-facing Application Load Balancer |
| Traffic routing | ALB Target Group and health checks |
| Compute | EC2 instances managed by an Auto Scaling Group |
| Capacity target | Minimum 2, desired 2, maximum 3 |
| Instance standardization | Launch Template and AMI |
| Block storage | EBS |
| Backup mechanism | EBS snapshots |
| Original implementation | AWS Management Console |
| IaC extension | Terraform reference implementation |

## 1. Problem statement

A web application hosted on one EC2 instance can become unavailable when that instance or its application fails. A single server can also become a bottleneck when incoming traffic increases. Replacing instances manually adds operational delay and makes configuration consistency harder.

This project explores an architecture that:

- Distributes incoming HTTP traffic across healthy application instances.
- Maintains a baseline of two EC2 instances.
- Replaces unhealthy or terminated instances to restore desired capacity.
- Allows capacity to increase up to three instances when a scaling policy is triggered.
- Uses a Launch Template and AMI to standardize instance provisioning.
- Uses EBS volumes and snapshots for block storage and point-in-time backup.

## 2. Architecture

See [`architecture/architecture.mmd`](architecture/architecture.mmd) and [`architecture/request-flow.md`](architecture/request-flow.md).

### Request path

1. A client resolves and sends a request to the ALB DNS name.
2. The internet-facing ALB accepts the request on its listener.
3. The ALB forwards eligible requests to its Target Group.
4. The Target Group health-checks registered EC2 instances.
5. The ALB routes new requests only to targets it considers healthy.
6. The ASG maintains the configured capacity and replaces instances when required.
7. When a configured scaling policy is triggered, the ASG can add capacity up to its maximum.

### Capacity configuration

| Setting | Value |
|---|---:|
| Minimum | 2 |
| Desired | 2 |
| Maximum | 3 |

**Important distinction:** An instance failure generally causes the ASG to replace an instance to restore desired capacity. A traffic-based scale-out requires a scaling policy or another scaling mechanism to trigger an increase from two to three. A failed instance does not, by itself, mean the group should permanently increase desired capacity.

## 3. AWS services and why they are used

| Service | Responsibility | Design reason |
|---|---|---|
| Amazon VPC | Network boundary | Isolates the project network |
| Public subnets | ALB placement | Provide internet reachability to the public ALB |
| Internet Gateway | Internet connectivity | Enables public-subnet routing |
| Application Load Balancer | Layer 7 entry point | Distributes HTTP requests across targets |
| Target Group | Target registration and health checks | Tracks target health and routing eligibility |
| EC2 | Application compute | Runs the web application |
| Auto Scaling Group | Capacity and replacement | Maintains desired instance count |
| Launch Template | Instance launch configuration | Makes instance provisioning repeatable |
| AMI | Machine image | Provides a reusable OS/application baseline |
| EBS | Block storage | Provides block devices to EC2 |
| EBS snapshots | Point-in-time backup | Supports volume recovery workflows |
| CloudWatch | Metrics and alarms | Can drive monitoring and scaling policies |

## 4. Failure scenarios

### Scenario A — EC2 instance terminates

The ASG detects that an instance is no longer part of the group and launches a replacement using its Launch Template. The group attempts to return to desired capacity. The ALB Target Group registers the replacement and considers it routable after successful health checks.

### Scenario B — Application health check fails

The Target Group marks the target unhealthy and stops routing new requests to it. If ASG ELB health-check integration is enabled, the ASG can also replace instances reported unhealthy by the load balancer. Health-check path, interval, timeout, thresholds, and application startup time must be configured carefully.

### Scenario C — Traffic increases

A configured target-tracking or step-scaling policy can increase desired capacity. In this reference design, capacity can grow from two to a maximum of three instances. Three instances are a deliberately small learning limit, not a claim that the application can handle any particular traffic volume.

### Scenario D — Availability Zone disruption

Spreading the ALB and ASG across multiple Availability Zones reduces dependence on one AZ. It does not guarantee uninterrupted service: capacity, subnet availability, application dependencies, and load-balancer health must all be considered.

### Scenario E — Data or volume loss

EBS snapshots provide point-in-time backups of volumes. A snapshot is not the same as application-level backup, database consistency, or a tested disaster-recovery plan. Recovery should be validated by restoring a volume and checking the data.

## 5. Engineering trade-offs

| Decision | Benefit | Cost / limitation |
|---|---|---|
| ALB instead of direct EC2 access | Stable entry point and health-aware routing | Additional hourly and usage cost |
| Minimum two instances | Baseline redundancy | Higher always-on compute cost |
| Maximum three instances | Caps lab capacity and cost exposure | May be insufficient for large traffic spikes |
| AMI-based provisioning | More consistent instance setup | AMIs need patching and lifecycle management |
| Launch Template | Repeatable launch configuration | Version management and rollout planning |
| EBS | Persistent block storage | AZ attachment constraints and storage cost |
| EBS snapshots | Recovery point creation | Snapshot storage cost; restore must be tested |
| Multi-AZ placement | Better AZ-level resilience | More network and capacity planning |
| Public ALB | Internet-facing entry point | Must secure listeners, TLS, and inbound rules |
| Public-subnet EC2 for a low-cost lab | Avoids NAT Gateway expense | Not the preferred production network posture |

### Production hardening note

The Terraform lab example places instances in public subnets without assigning public IP addresses, and restricts inbound application traffic to the ALB security group. This keeps the example simpler and avoids the recurring cost of a NAT Gateway, but it also means instances do not have ordinary outbound internet access for package installation. The sample user data therefore only writes a simple page and starts the preinstalled web server if present; validate the AMI/bootstrap behavior before using it.

For a production design, place application instances in private subnets and use controlled egress such as NAT, VPC endpoints, or baked application AMIs. Add HTTPS with ACM, least-privilege IAM, logging, patching, secrets management, WAF where appropriate, and tested backup/recovery procedures.

## 6. Design questions worth discussing in interviews

1. Why put an ALB in front of an ASG rather than expose EC2 instances directly?
2. What is the difference between an unhealthy Target Group target and an EC2 instance failing an EC2 status check?
3. Why does ASG replacement restore desired capacity rather than necessarily increase capacity?
4. What is the difference between desired capacity and a scaling policy?
5. Why use a Launch Template and AMI together?
6. What are the limitations of EBS snapshots for application-consistent backups?
7. Why should application instances generally be private in a production VPC?
8. What happens if the application needs shared files across multiple EC2 instances?
9. How would you monitor latency, 5xx errors, unhealthy hosts, CPU, and scaling activity?
10. What happens when demand exceeds the configured maximum capacity?

## 7. Terraform extension

The `terraform/` folder contains a reference implementation intended to recreate a small version of the architecture. It demonstrates:

- AWS provider and version constraints.
- Variables, locals, outputs, and data sources.
- VPC, subnets, route tables, and Internet Gateway.
- Security groups.
- Application Load Balancer, listener, and Target Group.
- Launch Template and Auto Scaling Group.
- Target tracking scaling policy.
- CloudWatch-backed scaling metrics.
- Terraform formatting, initialization, validation, planning, and apply workflow.

The Terraform code is not evidence that the original console-built environment was provisioned by Terraform. Review the code, configure variables, inspect `terraform plan`, and only apply when you understand the resources and costs.

### Run Terraform (only when ready)

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars
terraform fmt -recursive
terraform init
terraform validate
terraform plan
# Apply only after reviewing the plan and expected AWS charges:
terraform apply
```

To remove resources created by this Terraform configuration:

```bash
terraform destroy
```

Do not run `terraform destroy` against infrastructure you need to keep. Terraform state must be preserved and protected. Never commit credentials, state files, or real `terraform.tfvars` files.

## 8. Screenshots and evidence

Add your own AWS Console screenshots to the matching folders under `screenshots/`. Suggested evidence:

- VPC and subnet layout, including AZ placement.
- EC2 instances and instance status.
- ASG minimum, desired, maximum capacity and activity history.
- Launch Template and version.
- ALB listeners and availability zones.
- Target Group health status and health-check settings.
- AMI details.
- EBS volume and snapshot status.
- A controlled failure/replacement test, if performed.

Redact account IDs, public IPs, private hostnames, access keys, tokens, and any sensitive information before publishing.

## 9. Resume-ready project bullets

Use only bullets that accurately describe work you personally completed:

- Designed a highly available AWS web application architecture using Application Load Balancer, EC2 Auto Scaling Groups, Target Groups, and Launch Templates.
- Configured Auto Scaling capacity with a minimum of two, desired capacity of two, and maximum capacity of three EC2 instances.
- Used AMI-based instance provisioning to standardize EC2 configuration during instance launches and replacement.
- Configured ALB Target Group health checks to identify unhealthy application targets and control traffic routing.
- Worked with EBS volumes and snapshots to understand persistent block storage and point-in-time recovery.
- Evaluated availability, scalability, cost, and operational-complexity trade-offs in the infrastructure design.

If you have not actually configured a traffic-based scaling policy, do not claim that you implemented or tested traffic-driven scale-out. If you have not tested an instance failure, describe it as a design capability rather than a demonstrated result.

## 10. Future improvements

- Recreate the console architecture using reusable Terraform modules.
- Move application instances into private subnets.
- Add HTTPS using AWS Certificate Manager.
- Add CloudWatch dashboards and alarms.
- Test instance replacement and traffic-based scale-out separately.
- Add an application deployment strategy and controlled instance refresh.
- Add CI/CD with a reviewed Terraform plan and approval before apply.
- Evaluate shared storage or managed database needs if the application becomes stateful.

## License

This repository is provided for learning and portfolio demonstration. See `LICENSE`.
