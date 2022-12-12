provider "aws" {
  region = var.region
}

locals {
  tags = {
    Project     = var.project
    Environment = var.env
  }
}

output "dns" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

module "s3-a" {
  source  = "./s3"
  project = var.project
  env     = var.env
  tags    = local.tags
}
