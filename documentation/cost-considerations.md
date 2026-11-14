# Cost considerations

AWS charges vary by region, instance type, hours used, storage, requests, and data transfer. Check the current AWS Pricing Calculator and account billing before deployment.

Potential cost drivers:

- Two or more EC2 instances running continuously.
- Application Load Balancer hourly and capacity-unit charges.
- EBS provisioned storage.
- EBS snapshot storage.
- Public IPv4 addresses where applicable.
- NAT Gateway hourly and data processing charges if private instances need internet egress.
- CloudWatch metrics, alarms, and log ingestion.
- Data transfer.

## Cost controls

- Use the smallest suitable instance type for a temporary lab.
- Set a deliberate ASG maximum capacity.
- Delete unused load balancers, EC2 instances, EBS volumes, snapshots, and public IP allocations.
- Remember that stopping EC2 does not stop every associated charge.
- Use billing alerts and review Cost Explorer.
- Run `terraform destroy` only for resources managed by this Terraform state and only when safe.
