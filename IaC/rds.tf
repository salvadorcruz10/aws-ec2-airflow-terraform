#-----------
# Database
#-----------

# -------------------------------------------------------------------------
# CREATE A SECURITY GROUP TO CONTROL WHAT REQUESTS CAN GO IN AND OUT OF RDS
# -------------------------------------------------------------------------

module "sg_database" {
  source                                                   = "terraform-aws-modules/security-group/aws"
  version                                                  = "3.2.0"
  name                                                     = "${module.airflow_labels.id}-database-sg"
  description                                              = "Security group for ${module.airflow_labels.id} database"
  vpc_id                                                   = data.aws_vpc.default.id
  ingress_cidr_blocks                                      = var.ingress_cidr_blocks
  number_of_computed_ingress_with_source_security_group_id = 1
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "postgresql-tcp"
      source_security_group_id = aws_security_group.sg_airflow.id
      description              = "Allow ${module.airflow_labels.id} machines"
    },
  ]
  tags = module.airflow_labels.tags
}

resource "aws_db_instance" "airflow_database" {
  identifier              = "${module.airflow_labels.id}-db"
  allocated_storage       = var.db_allocated_storage
  engine                  = "postgres"
  engine_version          = "11.5"
  instance_class          = var.db_instance_type
  name                    = var.db_dbname
  username                = var.db_username
  password                = var.db_password
  storage_type            = "gp2"
  backup_retention_period = 7
  multi_az                = false
  publicly_accessible     = false
  apply_immediately       = true
  skip_final_snapshot     = true
  vpc_security_group_ids  = [module.sg_database.this_security_group_id]
  port                    = "5432"
  db_subnet_group_name    = var.db_subnet_group_name
}
