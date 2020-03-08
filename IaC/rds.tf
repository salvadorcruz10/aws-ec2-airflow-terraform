#-----------
# Database
#-----------

# -------------------------------------------------------------------------
# CREATE A SECURITY GROUP TO CONTROL WHAT REQUESTS CAN GO IN AND OUT OF RDS
# -------------------------------------------------------------------------

resource "aws_db_subnet_group" "this" {
  name       = "airflow_db_subnet_group"
  subnet_ids = [aws_subnet.sub_public1.id,aws_subnet.sub_public2.id]
  tags = merge(map("Name", "${var.prefix_name}-db-subnet-group"), var.tags)
}

resource "aws_security_group" "database_sg" {
  name = "${var.prefix_name}-database-sg"
  description = "Security group for ${var.db_dbname} database"
  vpc_id      = aws_vpc.airflow.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.sg_airflow.id]
  }

  tags = merge(map("Name", "${var.prefix_name}-database-security-group"), var.tags)

}

resource "aws_db_instance" "airflow_database" {
  identifier              = "${var.prefix_name}-db"
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
  vpc_security_group_ids  = [aws_security_group.database_sg.id]
  port                    = "5432"
  db_subnet_group_name    =  aws_db_subnet_group.this.name
}
