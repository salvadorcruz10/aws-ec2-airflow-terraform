# ---------------------------------------
# CREATE A SQS TOPIC
# ---------------------------------------

resource "aws_sqs_queue" "airflow_queue" {
  name             = "${var.tag_airflow}-sqs"
  max_message_size = 262144

  tags = {
    Name  = "${var.tag_airflow}-sqs"
    Stage = var.environment
    Team  = "Airflow-${var.team}"
  }
}
