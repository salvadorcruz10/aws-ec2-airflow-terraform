# ---------------------------------------
# AIRFLOW CLUSTER RESOURCES
# ---------------------------------------

# ---------------------------------------
# LABELS
# ---------------------------------------

resource "aws_key_pair" "auth" {
  key_name   = coalesce(var.key_name, module.airflow_labels.id)
  public_key = coalesce(var.public_key, file(var.public_key_path))
}

# ---------------------------------------
# Policies and profile
# ---------------------------------------

module "ami_instance_profile" {
  source         = "git::https://github.com/traveloka/terraform-aws-iam-role//modules/instance?ref=tags/v1.0.2"
  service_name   = module.airflow_labels.namespace
  cluster_role   = module.airflow_labels.stage
  environment    = module.airflow_labels.stage
  product_domain = module.airflow_labels.stage
  role_tags      = module.airflow_labels.tags
}

resource "aws_iam_role_policy_attachment" "s3_policy" {
  role       = module.ami_instance_profile.role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "sqs_policy" {
  role       = module.ami_instance_profile.role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

resource "aws_sqs_queue_policy" "sqs_permission" {
  queue_url = aws_sqs_queue.airflow_queue.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "SQS:*",
      "Resource": "${aws_sqs_queue.airflow_queue.arn}"
    }
  ]
}
POLICY

}


