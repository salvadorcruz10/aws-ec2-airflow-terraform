
# ----------------------------------------------------------------------------------------
# CREATE A SECURITY GROUP TO CONTROL WHAT REQUESTS CAN GO IN AND OUT OF EACH EC2 INSTANCE
# ----------------------------------------------------------------------------------------

resource "aws_security_group" "sg_airflow" {
  name        = "airflow-sg"
  description = "Security group for airflow"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"] # add a CIDR block here
  }

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"] # add a CIDR block here
  }

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"] # add a CIDR block here
  }

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 5555
    to_port     = 5555
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"] # add a CIDR block here
  }

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"] # add a CIDR block here
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    #prefix_list_ids = ["pl-12c4e678"]
  }
}


#-------------------------------------------------------------------------
# EC2
#-------------------------------------------------------------------------
resource "aws_instance" "airflow_webserver" {
  count = 1

  instance_type          = var.webserver_instance_type
  ami                    = var.ami
  key_name               = aws_key_pair.auth.id
  vpc_security_group_ids = [aws_security_group.sg_airflow.id]
  subnet_id              = coalesce(var.instance_subnet_id, tolist(data.aws_subnet_ids.all.ids)[0])
  iam_instance_profile   = module.ami_instance_profile.instance_profile_name

  associate_public_ip_address = true

  volume_tags = module.airflow_labels_webserver.tags

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    delete_on_termination = var.root_volume_delete_on_termination
  }

  provisioner "file" {
    content     = data.template_file.custom_env.rendered
    destination = "/tmp/custom_env"

    connection {
      host        = self.public_ip
      agent       = false
      type        = "ssh"
      user        = "ubuntu"
      private_key = coalesce(var.private_key, file(var.private_key_path))
    }
  }

  provisioner "file" {
    content     = data.template_file.custom_requirements.rendered
    destination = "/tmp/requirements.txt"

    connection {
      host        = self.public_ip
      agent       = false
      type        = "ssh"
      user        = "ubuntu"
      private_key = coalesce(var.private_key, file(var.private_key_path))
    }
  }

  provisioner "file" {
    content     = data.template_file.airflow_environment.rendered
    destination = "/tmp/airflow_environment"

    connection {
      host        = self.public_ip
      agent       = false
      type        = "ssh"
      user        = "ubuntu"
      private_key = coalesce(var.private_key, file(var.private_key_path))
    }
  }

  provisioner "file" {
    content     = data.template_file.airflow_service.rendered
    destination = "/tmp/airflow.service"

    connection {
      host        = self.public_ip
      agent       = false
      type        = "ssh"
      user        = "ubuntu"
      private_key = coalesce(var.private_key, file(var.private_key_path))
    }
  }

  provisioner "remote-exec" {
    inline = [
      "echo AIRFLOW_ROLE=WEBSERVER | sudo tee -a /etc/environment",
    ]

    connection {
      host        = self.public_ip
      agent       = false
      type        = "ssh"
      user        = "ubuntu"
      private_key = coalesce(var.private_key, file(var.private_key_path))
    }
  }

  user_data = data.template_file.provisioner.rendered
  tags      = module.airflow_labels_webserver.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "airflow_scheduler" {
  count = 1

  instance_type          = var.scheduler_instance_type
  ami                    = var.ami
  key_name               = aws_key_pair.auth.id
  vpc_security_group_ids = [aws_security_group.sg_airflow.id]
  subnet_id              = coalesce(var.instance_subnet_id, tolist(data.aws_subnet_ids.all.ids)[0])
  iam_instance_profile   = module.ami_instance_profile.instance_profile_name

  associate_public_ip_address = true

  volume_tags = module.airflow_labels_webserver.tags

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    delete_on_termination = var.root_volume_delete_on_termination
  }

  provisioner "file" {
    content     = data.template_file.custom_env.rendered
    destination = "/tmp/custom_env"

    connection {
      host        = self.public_ip
      agent       = false
      type        = "ssh"
      user        = "ubuntu"
      private_key = coalesce(var.private_key, file(var.private_key_path))
    }
  }

  provisioner "file" {
    content     = data.template_file.custom_requirements.rendered
    destination = "/tmp/requirements.txt"

    connection {
      host        = self.public_ip
      agent       = false
      type        = "ssh"
      user        = "ubuntu"
      private_key = coalesce(var.private_key, file(var.private_key_path))
    }
  }

  provisioner "file" {
    content     = data.template_file.airflow_environment.rendered
    destination = "/tmp/airflow_environment"

    connection {
      host        = self.public_ip
      agent       = false
      type        = "ssh"
      user        = "ubuntu"
      private_key = coalesce(var.private_key, file(var.private_key_path))
    }
  }

  provisioner "file" {
    content     = data.template_file.airflow_service.rendered
    destination = "/tmp/airflow.service"

    connection {
      host        = self.public_ip
      agent       = false
      type        = "ssh"
      user        = "ubuntu"
      private_key = coalesce(var.private_key, file(var.private_key_path))
    }
  }

  provisioner "remote-exec" {
    inline = [
      "echo AIRFLOW_ROLE=SCHEDULER | sudo tee -a /etc/environment",
    ]

    connection {
      host        = self.public_ip
      agent       = false
      type        = "ssh"
      user        = "ubuntu"
      private_key = coalesce(var.private_key, file(var.private_key_path))
    }
  }

  user_data = data.template_file.provisioner.rendered
  tags      = module.airflow_labels_scheduler.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "airflow_worker" {
  count = var.worker_instance_count

  instance_type          = var.worker_instance_type
  ami                    = var.ami
  key_name               = aws_key_pair.auth.id
  vpc_security_group_ids = [aws_security_group.sg_airflow.id]
  subnet_id              = coalesce(var.instance_subnet_id, tolist(data.aws_subnet_ids.all.ids)[0])
  iam_instance_profile   = module.ami_instance_profile.instance_profile_name

  associate_public_ip_address = true

  volume_tags = module.airflow_labels_webserver.tags

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    delete_on_termination = var.root_volume_delete_on_termination
  }

  provisioner "file" {
    content     = data.template_file.custom_env.rendered
    destination = "/tmp/custom_env"

    connection {
      host        = self.public_ip
      agent       = false
      type        = "ssh"
      user        = "ubuntu"
      private_key = coalesce(var.private_key, file(var.private_key_path))
    }
  }

  provisioner "file" {
    content     = data.template_file.custom_requirements.rendered
    destination = "/tmp/requirements.txt"

    connection {
      host        = self.public_ip
      agent       = false
      type        = "ssh"
      user        = "ubuntu"
      private_key = coalesce(var.private_key, file(var.private_key_path))
    }
  }

  provisioner "file" {
    content     = data.template_file.airflow_environment.rendered
    destination = "/tmp/airflow_environment"

    connection {
      host        = self.public_ip
      agent       = false
      type        = "ssh"
      user        = "ubuntu"
      private_key = coalesce(var.private_key, file(var.private_key_path))
    }
  }

  provisioner "file" {
    content     = data.template_file.airflow_service.rendered
    destination = "/tmp/airflow.service"

    connection {
      host        = self.public_ip
      agent       = false
      type        = "ssh"
      user        = "ubuntu"
      private_key = coalesce(var.private_key, file(var.private_key_path))
    }
  }

  provisioner "remote-exec" {
    inline = [
      "echo AIRFLOW_ROLE=WORKER | sudo tee -a /etc/environment",
    ]

    connection {
      host        = self.public_ip
      agent       = false
      type        = "ssh"
      user        = "ubuntu"
      private_key = coalesce(var.private_key, file(var.private_key_path))
    }
  }

  user_data = data.template_file.provisioner.rendered
  tags      = module.airflow_labels_worker.tags

  lifecycle {
    create_before_destroy = true
  }
}
