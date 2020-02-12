# ---------------------------------------
# CREATE A SQS TOPIC
# ---------------------------------------

resource "aws_sqs_queue" "airflow_queue" {
  name             = "${module.airflow_labels.id}-queue"
  max_message_size = 262144

  tags = module.airflow_labels.tags
}

