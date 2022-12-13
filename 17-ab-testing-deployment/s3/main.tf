resource "aws_s3_bucket" "web" {
  bucket        = "${var.project}-${var.env}-${var.div}-bucket"
  force_destroy = true

  tags = {
    Project     = var.project
    Environment = var.env
  }
}

resource "aws_s3_bucket_acl" "web_acl" {
  bucket = aws_s3_bucket.web.id
  acl    = "private"
}

resource "aws_s3_bucket_website_configuration" "web_config" {
  bucket = aws_s3_bucket.web.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "web_policy" {
  bucket = aws_s3_bucket.web.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.web.arn}/*"
        Principal = {
          AWS = var.principal_arn
        }
      },
    ]
  })
}

output "web" {
  value = aws_s3_bucket.web
}
