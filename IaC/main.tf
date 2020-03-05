# ---------------------------------------
# AIRFLOW CLUSTER RESOURCES
# ---------------------------------------

resource "aws_key_pair" "auth" {
  key_name   = var.key_name
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

# ---------------------------------------
# Customized VPC
# ---------------------------------------

resource "aws_vpc" "main" {
  cidr_block           = "10.16.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name  = "${var.tag_airflow}-vpcid"
    Stage = var.environment
    Team  = "Airflow-${var.team}"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.16.0.0/24"
  availability_zone = var.azs["1"]

  tags = {
    Name  = "${var.tag_airflow}-subnet1"
    Stage = var.environment
    Team  = "Airflow-${var.team}"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.16.1.0/24"
  availability_zone = var.azs["2"]

  tags = {
    Name  = "${var.tag_airflow}-subnet2"
    Stage = var.environment
    Team  = "Airflow-${var.team}"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name  = "${var.tag_airflow}-route-table"
    Stage = var.environment
    Team  = "Airflow-${var.team}"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "rt_subnet1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "rt_subnet2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name  = "${var.tag_airflow}-ig"
    Stage = var.environment
    Team  = "Airflow-${var.team}"
  }
}

