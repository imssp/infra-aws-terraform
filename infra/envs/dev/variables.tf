variable "aws_region" {
  description = "AWS region."
  type        = string
}

variable "aws_access_key" {
  description = "Plan-only AWS access key placeholder. Prefer environment credentials for real deployments."
  type        = string
  sensitive   = true
  default     = "mock_access_key"
}

variable "aws_secret_key" {
  description = "Plan-only AWS secret key placeholder. Prefer environment credentials for real deployments."
  type        = string
  sensitive   = true
  default     = "mock_secret_key"
}

variable "project_name" {
  description = "Short project name used in resource names."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
}

variable "availability_zones" {
  description = "Availability zones used by subnets."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks."
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Whether private subnets route outbound traffic through a NAT gateway."
  type        = bool
}

variable "container_image" {
  description = "Application container image."
  type        = string
}

variable "container_port" {
  description = "Application container port."
  type        = number
}

variable "desired_count" {
  description = "Desired ECS service task count."
  type        = number
}

variable "task_cpu" {
  description = "Fargate task CPU units."
  type        = number
}

variable "task_memory" {
  description = "Fargate task memory in MB."
  type        = number
}

variable "db_name" {
  description = "Initial RDS database name."
  type        = string
}

variable "db_username" {
  description = "RDS master username."
  type        = string
}

variable "db_password" {
  description = "RDS master password."
  type        = string
  sensitive   = true
}

variable "db_engine_version" {
  description = "PostgreSQL engine version."
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
}

variable "db_allocated_storage" {
  description = "Initial RDS storage in GB."
  type        = number
}

variable "db_max_allocated_storage" {
  description = "Maximum RDS storage autoscaling size in GB."
  type        = number
}

variable "db_multi_az" {
  description = "Whether RDS should be Multi-AZ."
  type        = bool
}

variable "rds_backup_retention_period" {
  description = "RDS backup retention in days."
  type        = number
}

variable "rds_deletion_protection" {
  description = "Whether RDS deletion protection is enabled."
  type        = bool
}

variable "rds_skip_final_snapshot" {
  description = "Whether RDS skips final snapshot on deletion."
  type        = bool
}

variable "tags" {
  description = "Additional tags."
  type        = map(string)
  default     = {}
}
