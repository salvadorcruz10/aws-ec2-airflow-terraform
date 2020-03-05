#-----------
# Database
#-----------

# -------------------------------------------------------------------------
# CREATE A SECURITY GROUP TO CONTROL WHAT REQUESTS CAN GO IN AND OUT OF RDS
# -------------------------------------------------------------------------

resource "aws_db_subnet_group" "mysubnetgroup" {
  name       = "mysubnetgroup"
  subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

  tags = {
    Name  = "${var.tag_airflow}-my-db-subnet-group"
    Stage = var.environment
    Team  = "Airflow-${var.team}"
  }

  depends_on = [aws_subnet.subnet1, aws_subnet.subnet2]
}

resource "aws_security_group" "sg_database" {
  name        = "${var.tag_airflow}-database-sg"
  description = "Security group for ${var.db_dbname} database"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_airflow.id]
  }

  tags = {
    Name      = "${var.tag_airflow}-database-sg"
    Namespace = var.tag_airflow
    Role      = "role-${var.tag_airflow}"
    Stage     = var.environment
    Team      = "Airflow-${var.team}"
  }

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
  vpc_security_group_ids  = [aws_security_group.sg_database.id]
  port                    = "5432"
  db_subnet_group_name    = aws_db_subnet_group.mysubnetgroup.name
}
