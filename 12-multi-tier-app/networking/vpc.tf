module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.12.0"

  name = "${var.project}-vpc"
  cidr = var.vpc_cidr
  azs  = data.aws_availability_zones.available.names

  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Project     = "${var.project}"
    Environment = "prod"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_db_subnet_group" "default" {
  name       = "${var.project}-db-subnet-group"
  subnet_ids = module.vpc.private_subnets

  depends_on = [
    module.vpc
  ]

  tags = {
    Name        = "${var.project}-db-subnet-group"
    Project     = "${var.project}"
    Environment = "prod"
  }
}
