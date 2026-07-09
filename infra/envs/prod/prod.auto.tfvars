aws_region   = "ap-south-1"
project_name = "hotel-platform"
environment  = "prod"

vpc_cidr = "10.20.0.0/16"
availability_zones = [
  "ap-south-1a",
  "ap-south-1b"
]
public_subnet_cidrs = [
  "10.20.0.0/24",
  "10.20.1.0/24"
]
private_subnet_cidrs = [
  "10.20.10.0/24",
  "10.20.11.0/24"
]
enable_nat_gateway = true

container_image = "nginx:1.27-alpine"
container_port  = 80
desired_count   = 2
task_cpu        = 512
task_memory     = 1024

db_name                  = "hotelbookings"
db_username              = "hotel_admin"
db_password              = "ChangeMeProdPassword123!"
db_engine_version        = "16.3"
db_instance_class        = "db.t4g.small"
db_allocated_storage     = 50
db_max_allocated_storage = 200
db_multi_az              = true

rds_backup_retention_period = 14
rds_deletion_protection     = true
rds_skip_final_snapshot     = false

tags = {
  CostCenter = "assessment"
  Owner      = "platform"
}
