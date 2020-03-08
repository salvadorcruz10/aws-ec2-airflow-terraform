# -------------------------------------------
# CREATE A S3 BUCKET TO STORAGE AIRFLOW LOGS
# -------------------------------------------

resource "aws_s3_bucket" "airflow_logs" {
  bucket        = var.s3_bucket_name
  acl           = "private"
  force_destroy = true
  tags          = merge(map("Name", "${var.prefix_name}-s3-bucket-logs"), var.tags)
}
