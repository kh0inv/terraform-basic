provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "static_web" {
  bucket = "test-name-bucket-123132"
}

resource "aws_s3_bucket_acl" "name" {
  bucket = aws_s3_bucket.static_web.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "name" {
  bucket = aws_s3_bucket.static_web.id
  policy = data.aws_iam_policy_document.allow_access_static_web.json
}

data "aws_iam_policy_document" "allow_access_static_web" {
  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.static_web.arn}/*"]
  }
}

resource "aws_s3_bucket_website_configuration" "name" {
  bucket = aws_s3_bucket.static_web.bucket

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "object" {
  for_each     = fileset(path.module, "source-static-web/**/*")
  bucket       = aws_s3_bucket.static_web.id
  key          = replace(each.value, "source-static-web", "")
  source       = each.value
  etag         = filemd5("${each.value}")
  content_type = lookup(local.mine_types, split(".", each.value)[length(split(".", each.value)) - 1])
}

locals {
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
