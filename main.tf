# Provider for AWS
# The credential also may be set as the environment variables:
# AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY as long the region AWS_DEFAULT_REGION


#mkdir keys
#ssh-keygen -q -f keys/aws_terraform -C aws_terraform_ssh_key -N ''
#chmod 400 keys/aws_terraform
#chmod 400 keys/aws_terraform.pub
#para conectarse a la instancia
#ssh -i ./keys/aws_terraform ec2-user@ec2-3-17-73-9.us-east-2.compute.amazonaws.com

resource "aws_security_group" "airflow_security_group" {
  name        = "airflow_security_group"
  description = "Allow SSH inbound traffic"
#  vpc_id      = "${aws_vpc.main.id}"

  ingress {
# TLS (change to whatever ports you need)
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
#TODO: Quiza restringir aca los ips??
    cidr_blocks = ["0.0.0.0/0"]
    description = "Permiso para acceder a la instancia por SSH"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "admin_key" {
	key_name   = "admin_key"
  public_key = "${var.public_key}"
}

provider "aws" {
	version = "~> 2.0"
	region = "us-east-2"
}

resource "aws_instance" "web" {
	ami           = "ami-0c64dd618a49aeee8"
	instance_type = "t2.micro"
	key_name = "admin_key"
	security_groups = ["airflow_security_group"]
}


