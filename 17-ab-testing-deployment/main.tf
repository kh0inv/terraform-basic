provider "aws" {
  region = local.region
}

locals {
  region  = "us-east-1"
  project = "mamnon"
  env     = "prod"
}

module "s3-a" {
  source        = "./s3"
  project       = local.project
  env           = local.env
  div           = "a"
  principal_arn = aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
}

output "dns" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}
