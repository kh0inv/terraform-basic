locals {
  project = "swim"
}

provider "aws" {
  region = "us-east-1"
}

module "networking" {
  source = "./networking"

  project         = local.project
  vpc_cidr        = "10.192.0.0/20"
  private_subnets = ["10.192.12.0/24", "10.192.13.0/24"]
  public_subnets  = ["10.192.10.0/24", "10.192.11.0/24"]
}

# module "database" {
#   source = "./database"
# }

# module "autoscaling" {
#   source = "./autoscaling"
# }
