## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| admin\_email | Admin email. Only If RBAC is enabled, this user will be created in the first run only. | `string` | `"admin@admin.com"` | no |
| admin\_lastname | Admin lastname. Only If RBAC is enabled, this user will be created in the first run only. | `string` | `"Doe"` | no |
| admin\_name | Admin name. Only If RBAC is enabled, this user will be created in the first run only. | `string` | `"John"` | no |
| admin\_password | Admin password. Only If RBAC is enabled. | `string` | `false` | no |
| admin\_username | Admin username used to authenticate. Only If RBAC is enabled, this user will be created in the first run only. | `string` | `"admin"` | no |
| ami | Default is `Ubuntu Server 18.04 LTS (HVM), SSD Volume Type.` | `string` | `"ami-0a313d6098716f372"` | no |
| aws\_profile | AWS Profile | `string` | `"default"` | no |
| aws\_region | AWS Region | `string` | `"us-east-1"` | no |
| azs | Run the EC2 Instances in these Availability Zones | `map(string)` | <pre>{<br>  "1": "us-east-1a",<br>  "2": "us-east-1b",<br>  "3": "us-east-1c",<br>  "4": "us-east-1d"<br>}</pre> | no |
| cluster\_name | The name of the Airflow cluster (e.g. airflow-xyz). This variable is used to namespace all resources created by this module. | `string` | n/a | yes |
| cluster\_stage | The stage of the Airflow cluster (e.g. prod). | `string` | `"dev"` | no |
| custom\_env | Path to custom airflow environments variables. | `string` | n/a | yes |
| custom\_requirements | Path to custom requirements.txt. | `string` | n/a | yes |
| db\_allocated\_storage | Dabatase disk size. | `string` | `20` | no |
| db\_dbname | PostgreSQL database name. | `string` | `"airflow"` | no |
| db\_instance\_type | Instance type for PostgreSQL database | `string` | `"db.t2.micro"` | no |
| db\_password | PostgreSQL password. | `string` | n/a | yes |
| db\_subnet\_group\_name | db subnet group, if assigned, db will create in that subnet, default create in default vpc | `string` | `""` | no |
| db\_username | PostgreSQL username. | `string` | `"airflow"` | no |
| environment | Tag used to identify resources | `string` | `"Dev"` | no |
| fernet\_key | Key for encrypting data in the database - see Airflow docs. | `string` | n/a | yes |
| ingress\_cidr\_blocks | List of IPv4 CIDR ranges to use on all ingress rules | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| ingress\_with\_cidr\_blocks | List of computed ingress rules to create where 'cidr\_blocks' is used | <pre>list(object({<br>    description = string<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    cidr_blocks = string<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": "0.0.0.0/0",<br>    "description": "Airflow webserver",<br>    "from_port": 8080,<br>    "protocol": "tcp",<br>    "to_port": 8080<br>  },<br>  {<br>    "cidr_blocks": "0.0.0.0/0",<br>    "description": "Airflow flower",<br>    "from_port": 5555,<br>    "protocol": "tcp",<br>    "to_port": 5555<br>  }<br>]</pre> | no |
| instance\_subnet\_id | subnet id used for ec2 instances running airflow, if not defined, vpc's first element in subnetlist will be used | `string` | `""` | no |
| key\_name | AWS KeyPair name. | `string` | `"airflow-key-name"` | no |
| load\_default\_conns | Load the default connections initialized by Airflow. Most consider these unnecessary, which is why the default is to not load them. | `bool` | `false` | no |
| load\_example\_dags | Load the example DAGs distributed with Airflow. Useful if deploying a stack for demonstrating a few topologies, operators and scheduling strategies. | `bool` | `false` | no |
| private\_key | Enter the content of the SSH Private Key to run provisioner. | `string` | n/a | yes |
| private\_key\_path | Enter the path to the SSH Private Key to run provisioner. | `string` | `"~/.ssh/id_rsa"` | no |
| public\_key | Enter the content of the SSH Public Key to run provisioner. | `string` | n/a | yes |
| public\_key\_path | Enter the path to the SSH Public Key to add to AWS. | `string` | `"~/.ssh/id_rsa.pub"` | no |
| rbac | Enable support for Role-Based Access Control (RBAC). | `string` | `false` | no |
| root\_volume\_delete\_on\_termination | Whether the volume should be destroyed on instance termination. | `bool` | `true` | no |
| root\_volume\_ebs\_optimized | If true, the launched EC2 instance will be EBS-optimized. | `bool` | `false` | no |
| root\_volume\_size | The size, in GB, of the root EBS volume. | `string` | `35` | no |
| root\_volume\_type | The type of volume. Must be one of: standard, gp2, or io1. | `string` | `"gp2"` | no |
| s3\_bucket\_name | S3 Bucket to save airflow logs. | `string` | `""` | no |
| scheduler\_instance\_type | Instance type for the Airflow Scheduler. | `string` | `"t3.micro"` | no |
| spot\_price | The maximum hourly price to pay for EC2 Spot Instances. | `string` | `""` | no |
| tag\_airflow | Tag used to identify resources | `string` | `"airflow"` | no |
| tags | Additional tags used into terraform-terraform-labels module. | `map(string)` | `{}` | no |
| team | Tag used to identify resources | `string` | `"Wizeline"` | no |
| vpc\_id | The ID of the VPC in which the nodes will be deployed.  Uses default VPC if not supplied. | `string` | n/a | yes |
| webserver\_instance\_type | Instance type for the Airflow Webserver. | `string` | `"t3.micro"` | no |
| webserver\_port | The port Airflow webserver will be listening. Ports below 1024 can be opened only with root privileges and the airflow process does not run as such. | `string` | `"8080"` | no |
| worker\_instance\_count | Number of worker instances to create. | `string` | `1` | no |
| worker\_instance\_type | Instance type for the Celery Worker. | `string` | `"t3.small"` | no |

## Outputs

| Name | Description |
|------|-------------|
| database\_endpoint | Endpoint to connect to RDS metadata DB |
| database\_username | Username to connect to RDS metadata DB |
| this\_cluster\_security\_group\_id | The ID of the security group |
| this\_database\_security\_group\_id | The ID of the security group |
| webserver\_admin\_url | Url for the Airflow Webserver Admin |
| webserver\_public\_ip | Public IP address for the Airflow Webserver instance |

