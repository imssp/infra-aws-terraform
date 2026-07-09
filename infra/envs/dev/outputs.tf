output "alb_dns_name" {
  description = "Public ALB DNS name."
  value       = module.ecs.alb_dns_name
}

output "ecs_cluster_name" {
  description = "ECS cluster name."
  value       = module.ecs.ecs_cluster_name
}

output "ecs_service_name" {
  description = "ECS service name."
  value       = module.ecs.ecs_service_name
}

output "rds_endpoint" {
  description = "Private RDS endpoint."
  value       = module.rds.db_endpoint
}

output "rds_security_group_id" {
  description = "RDS security group ID."
  value       = module.rds.rds_security_group_id
}
