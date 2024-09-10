# Deploy the RDS instance
# resource "aws_db_instance" "postgresql_rds" {
#   allocated_storage                   = var.rds_min_storage
#   auto_minor_version_upgrade          = true
#   availability_zone                   = var.rds_az
#   backup_retention_period             = var.rds_backup_retention_days
#   backup_target                       = "region"
#   backup_window                       = "03:09-03:39"
#   copy_tags_to_snapshot               = true
#   db_name                             = "fastenProd"
#   dedicated_log_volume                = false
#   deletion_protection                 = true
#   engine                              = "postgres"
#   engine_lifecycle_support            = "open-source-rds-extended-support"
#   engine_version                      = "15.5"
#   iam_database_authentication_enabled = false
#   identifier                          = "prd-fasten"
#   instance_class                      = var.rds_instance_class
#   license_model                       = "postgresql-license"
#   maintenance_window                  = "wed:07:53-wed:08:23"
#   max_allocated_storage               = var.rds_max_storage
#   multi_az                            = var.rds_multi_az
#   network_type                        = "IPV4"
#   option_group_name                   = "default:postgres-15"
#   parameter_group_name                = "default.postgres15"
#   performance_insights_enabled        = false
#   port                                = var.rds_port
#   publicly_accessible                 = var.rds_publicly_accessible
#   storage_encrypted                   = true
#   storage_type                        = var.rds_storage_type
#   username                            = "postgres"
#   password                            = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["password"]
#   vpc_security_group_ids              = [aws_security_group.allow_rds_access.id]
#   skip_final_snapshot                 = true
# }

# # Create a security group to attach to the RDS instance
# resource "aws_security_group" "allow_rds_access" {
#   name        = "allow_rds_access"
#   description = "Allow access to the fasten postgresql rds instance"

#   tags = {
#     Name = "allow_rds_access"
#   }
# }

# # Allow ingress into the RDS instance fro a list of CIDR blocks
# resource "aws_vpc_security_group_ingress_rule" "allow_rds_ingress" {
#   for_each          = toset(var.rds_allow_ingress_ips)
#   security_group_id = aws_security_group.allow_rds_access.id
#   description       = "Allow ingress on port 5432 from ${each.key}"
#   cidr_ipv4         = each.key
#   from_port         = 5432
#   ip_protocol       = "tcp"
#   to_port           = 5432
# }

# # Declare data source to fetch the secret
# data "aws_secretsmanager_secret" "secrets" {
#   name = "fasten_rds"
# }

# data "aws_secretsmanager_secret_version" "current" {
#   secret_id = data.aws_secretsmanager_secret.secrets.id
# }