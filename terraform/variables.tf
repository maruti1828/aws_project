variable "aws_region" {
  description = "AWS region for this lab."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Short name used in resource names."
  type        = string
  default     = "ha-webapp"
}

variable "vpc_cidr" {
  description = "CIDR block for the project VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Two public subnet CIDRs, one per Availability Zone."
  type        = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24"]

  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Provide exactly two public subnet CIDR blocks."
  }
}

variable "instance_type" {
  description = "EC2 instance type. Check current regional pricing and eligibility."
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "Minimum ASG capacity."
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Desired ASG capacity."
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum ASG capacity."
  type        = number
  default     = 3
}

variable "target_cpu_utilization" {
  description = "Average CPU target for target-tracking scaling."
  type        = number
  default     = 50
}

variable "allowed_http_cidr" {
  description = "CIDR allowed to reach the ALB over HTTP. Restrict for non-public testing."
  type        = string
  default     = "0.0.0.0/0"
}

variable "health_check_path" {
  description = "HTTP path used by the ALB Target Group health check."
  type        = string
  default     = "/"
}
