output "alb_dns_name" {
  description = "DNS name of the public Application Load Balancer."
  value       = aws_lb.app.dns_name
}

output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.main.id
}

output "autoscaling_group_name" {
  description = "Auto Scaling Group name."
  value       = aws_autoscaling_group.app.name
}

output "target_group_arn" {
  description = "Target Group ARN."
  value       = aws_lb_target_group.app.arn
}

output "availability_zones" {
  description = "Availability Zones used by the public subnets."
  value       = local.az_names
}
