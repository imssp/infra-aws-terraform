output "db_instance_identifier" {
  description = "RDS instance identifier."
  value       = aws_db_instance.this.identifier
}

output "db_endpoint" {
  description = "RDS endpoint address."
  value       = aws_db_instance.this.address
}

output "db_port" {
  description = "RDS PostgreSQL port."
  value       = aws_db_instance.this.port
}

output "rds_security_group_id" {
  description = "Security group ID attached to RDS."
  value       = aws_security_group.rds.id
}
