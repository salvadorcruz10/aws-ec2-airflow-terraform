# ---------------------------------------
# CREATE A SQS TOPIC
# ---------------------------------------

resource "aws_sqs_queue" "airflow_queue" {
  name             = "${var.prefix_name}-sqs"
  max_message_size = 262144
  tags = merge(map("Name", "${var.prefix_name}-sqs"), var.tags)
}
