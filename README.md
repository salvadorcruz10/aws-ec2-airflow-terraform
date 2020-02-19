# AWS-ec2-airflow

Project designed to deploy an Apache Airflow cluster on AWS, backed by RDS PostgreSQL for metadata, S3 for logs and SQS as message broker with CeleryExecutor
                                                           
This project uses basically Terraform to build all the infrastructure as needed according to parameters provided. 

### Prerequisites

Have SSH keys configured without a passphrase using:
```
ssh-keygen -t rsa -b 4096
```

### Terraform version

0.12.6

### How to deploy an environment

In [terraform.tfvars](IaC2/terraform.tfvars) file configure parameters for your infrastructure, for example

```
webserver_instance_type = "t2.micro"
scheduler_instance_type = "t2.micro"
worker_instance_type    = "t2.micro"
```
Run Terraform's init command with its configuration file

```
terraform init -reconfigure -backend-config=backend_vars 
```

Run Terraform's plan command to have an insight of the infrastructure

```
terraform plan -var-file=terraform.tfvars 
```

Run Terraform apply command to build your infrastructure

```
terraform apply -var-file=terraform.tfvars
```

Run Terraform destroy command to delete your infrastructure

```
terraform destroy -var-file=terraform.tfvars
```

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) to know about the process for submitting pull requests to us.

## License

This project is licensed under the Apache License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Inspired on project built by [PowerDataHub Project](https://github.com/PowerDataHub/terraform-aws-airflow)
