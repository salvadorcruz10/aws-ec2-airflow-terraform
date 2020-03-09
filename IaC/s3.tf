# -------------------------------------------
# CREATE A S3 BUCKET TO STORAGE AIRFLOW LOGS
# -------------------------------------------

resource "aws_s3_bucket" "airflow_logs" {
  bucket        = var.s3_bucket_name
  acl           = "private"
  force_destroy = true

  tags = {
    Name  = var.s3_bucket_name
    Stage = var.environment
    Team  = "Airflow-${var.team}"
  }
}
