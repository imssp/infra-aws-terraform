variable "project_name" {
  description = "Short project name used in resource names."
  type        = string
}

variable "environment" {
  description = "Environment name, such as dev or prod."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the database subnet group."
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "Security group ID for ECS tasks that may connect to RDS."
  type        = string
}

variable "db_name" {
  description = "Initial PostgreSQL database name."
  type        = string
}

variable "db_username" {
  description = "RDS master username."
  type        = string
}

variable "db_password" {
  description = "RDS master password. Demo tfvars include a placeholder; use a secret manager for real deployments."
  type        = string
  sensitive   = true
}

variable "engine_version" {
  description = "PostgreSQL engine version."
  type        = string
  default     = "16.3"
}

variable "instance_class" {
  description = "RDS instance class."
  type        = string
}

variable "allocated_storage" {
  description = "Initial allocated storage in GB."
  type        = number
}

variable "max_allocated_storage" {
  description = "Maximum storage autoscaling size in GB."
  type        = number
}

variable "multi_az" {
  description = "Whether the RDS instance is Multi-AZ."
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "RDS backup retention in days."
  type        = number
}

variable "deletion_protection" {
  description = "Whether deletion protection is enabled for RDS."
  type        = bool
}

variable "skip_final_snapshot" {
  description = "Whether to skip final snapshot on DB deletion."
  type        = bool
}

variable "apply_immediately" {
  description = "Whether RDS changes should apply immediately."
  type        = bool
  default     = false
}

variable "backup_window" {
  description = "Preferred backup window."
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "Preferred maintenance window."
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "tags" {
  description = "Additional resource tags."
  type        = map(string)
  default     = {}
}
