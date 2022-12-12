resource "aws_s3_bucket" "backend_bucket" {
  bucket        = "${var.project}-s3-backend"

  tags = local.tags
}

resource "aws_s3_bucket_acl" "backend_acl" {
  bucket = aws_s3_bucket.backend_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "backend_versioning" {
  bucket = aws_s3_bucket.backend_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_kms_key" "backend_key" {
  description = "This key is used to encrypt objects in backend bucket"
  tags = local.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backend_encryption_config" {
  bucket = aws_s3_bucket.backend_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.backend_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
