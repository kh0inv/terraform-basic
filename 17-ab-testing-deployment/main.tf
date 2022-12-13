provider "aws" {
  region = local.region
}

locals {
  region  = "us-east-1"
  project = "mamnon"
  env     = "prod"

  tags = {
    Project     = local.project
    Environment = local.env
  }

  mine_types = {
    html  = "text/html"
    css   = "text/css"
    ttf   = "font/ttf"
    woff  = "font/woff"
    woff2 = "font/woff2"
    js    = "application/javascript"
    map   = "application/javascript"
    json  = "application/json"
    jpg   = "image/jpeg"
    png   = "image/png"
    svg   = "image/svg+xml"
    eot   = "application/vnd.ms-fontobject"
  }
}

module "web_a" {
  source        = "./hosting-bucket"
  project       = local.project
  env           = local.env
  div           = "a"
  principal_arn = aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
}

resource "aws_s3_object" "object" {
  for_each     = fileset(path.module, "source-static-web/**/*")
  bucket       = module.web_a.web.id
  key          = replace(each.value, "source-static-web", "")
  source       = each.value
  etag         = filemd5("${each.value}")
  content_type = lookup(local.mine_types, split(".", each.value)[length(split(".", each.value)) - 1])
}

module "web_b" {
  source        = "./hosting-bucket"
  project       = local.project
  env           = local.env
  div           = "b"
  principal_arn = aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
}

resource "aws_s3_object" "web_b_object" {
  for_each     = fileset(path.module, "source-static-web/**/*")
  bucket       = module.web_b.web.id
  key          = replace(each.value, "source-static-web", "")
  source       = each.value
  etag         = filemd5("${each.value}")
  content_type = lookup(local.mine_types, split(".", each.value)[length(split(".", each.value)) - 1])
}

output "dns" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "bucket_domain_name" {
  value = {
    a = module.web_a.web.bucket_domain_name
    b = module.web_b.web.bucket_domain_name
  }
}
