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

variable "public_subnet_ids" {
  description = "Public subnet IDs for the ALB."
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for Fargate tasks."
  type        = list(string)
}

variable "aws_region" {
  description = "AWS region used by the CloudWatch Logs driver."
  type        = string
}

variable "container_image" {
  description = "Application container image."
  type        = string
}

variable "container_port" {
  description = "Application container port exposed to the ALB target group."
  type        = number
  default     = 80
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

variable "health_check_path" {
  description = "ALB health check path."
  type        = string
  default     = "/"
}

variable "alb_deletion_protection" {
  description = "Whether deletion protection is enabled for the ALB."
  type        = bool
  default     = false
}

variable "container_environment" {
  description = "Environment variables passed to the application container."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "tags" {
  description = "Additional resource tags."
  type        = map(string)
  default     = {}
}
