locals {
  project  = "mamnon"
  key_name = "admin-khoinv-key"
  env      = "prod"
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

module "database" {
  source = "./database"

  project        = local.project
  subnet_group   = module.networking.db_subnet_group
  security_group = module.networking.security_groups

  depends_on = [
    module.networking
  ]
}

module "autoscaling" {
  source = "./autoscaling"

  project                  = local.project
  vpc                      = module.networking.vpc
  security_groups          = module.networking.security_groups
  key_name                 = "admin-khoinv-key"
  web_instance_profile_arn = module.role.ec2_instance_profile.arn

  depends_on = [
    module.role,
    module.networking
  ]
}

module "role" {
  source  = "./role"
  project = local.project
}

resource "aws_instance" "bastion" {
  instance_type   = "t2.micro"
  ami             = "ami-0574da719dca65348"
  key_name        = local.key_name
  subnet_id       = module.networking.vpc.public_subnets[0]
  security_groups = [module.networking.security_groups.bastion]

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    tags = {
      Name        = "${local.project}-bastion-volume"
      Project     = local.project
      Environment = local.env
    }
  }

  depends_on = [
    module.networking
  ]

  tags = {
    Name        = "${local.project}-bastion"
    Project     = local.project
    Environment = local.env
  }
}
