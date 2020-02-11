# Define AWS as our provider
provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

