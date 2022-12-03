provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "web_static" {
  bucket = "test-name-s3"
  # acl = "public-read"
  # policy = file("s3_web_static_policy")
  # website {
  #   index_document = "index.html"
  #   error_document = "error.html"
  # }
}

resource "aws_s3_bucket_acl" "web_static_acl" {
  bucket = aws_s3_bucket.web_static.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "web_static_policy" {
  bucket = aws_s3_bucket.web_static.id
  policy = data.aws_iam_policy_document.allow_acces_web_static.json
}

data "aws_iam_policy_document" "allow_acces_web_static" {
  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.web_static.arn}/*"]
  }
}

resource "aws_s3_bucket_website_configuration" "web_static_web" {
  bucket = aws_s3_bucket.web_static.bucket
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}
