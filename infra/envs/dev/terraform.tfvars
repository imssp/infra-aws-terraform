aws_region   = "ap-south-1"
project_name = "hotel-platform"
environment  = "dev"

vpc_cidr = "10.10.0.0/16"
availability_zones = [
  "ap-south-1a",
  "ap-south-1b"
]
public_subnet_cidrs = [
  "10.10.0.0/24",
  "10.10.1.0/24"
]
private_subnet_cidrs = [
  "10.10.10.0/24",
  "10.10.11.0/24"
]
enable_nat_gateway = true

container_image = "nginx:1.27-alpine"
container_port  = 80
desired_count   = 1
task_cpu        = 256
task_memory     = 512

db_name                  = "hotelbookings"
db_username              = "hotel_admin"
db_password              = "ChangeMeDevPassword123!"
db_engine_version        = "16.3"
db_instance_class        = "db.t4g.micro"
db_allocated_storage     = 20
db_max_allocated_storage = 50
db_multi_az              = false

rds_backup_retention_period = 3
rds_deletion_protection     = false
rds_skip_final_snapshot     = true

tags = {
  CostCenter = "assessment"
  Owner      = "platform"
}
