aws_region        = "us-east-1"
aws_profile       = "salvador"
environment       = "development"
cluster_name      = "airflow-example-deploy"
s3_bucket_name    = "airflow-example-deploy-logs2"
#fernet_key        = "HeY9Aivs7vADx5oy7SBKHfRJdj3fhpD_6IX2LnlDN74=" # Just for example purposes, for real projects you may want to create a terraform.tfvars file
key_name          = "airflow-key-2"
private_key_path  = "~/.ssh/airflow/id_rsa"
public_key_path   = "~/.ssh/airflow/id_rsa.pub"
vpc_id            = "vpc-7621aa0c"    #Could be created for further developments
load_example_dags = true

#custom_env        = "./.env.custom.airflow" # This envs will be appended and sourced by the airflow and OS system
custom_requirements = "./requirements.txt"
tags = {
  Role = "airflow-infrastructure"
  Team = "AI Labs"
}
rbac           = false

/**** Instance types *****/
webserver_instance_type = "t2.micro"
scheduler_instance_type = "t2.micro"
worker_instance_type    = "t2.micro"
worker_instance_count   = 1


/**** Database *****/
db_instance_type        = "db.t2.micro"
db_username             = "airflow"
db_dbname               = "airflow"
#db_password             = "123456789A*"    # Just for example purposes, for real projects you may want to create a terraform.tfvars file
