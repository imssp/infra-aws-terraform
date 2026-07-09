output "alb_dns_name" {
  description = "DNS name of the public application load balancer."
  value       = aws_lb.this.dns_name
}

output "alb_security_group_id" {
  description = "Security group ID attached to the ALB."
  value       = aws_security_group.alb.id
}

output "ecs_security_group_id" {
  description = "Security group ID attached to Fargate tasks."
  value       = aws_security_group.ecs.id
}

output "ecs_cluster_name" {
  description = "ECS cluster name."
  value       = aws_ecs_cluster.this.name
}

output "ecs_service_name" {
  description = "ECS service name."
  value       = aws_ecs_service.app.name
}
