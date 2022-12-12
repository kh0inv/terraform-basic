resource "aws_s3_bucket" "be_bucket" {
  bucket = "${var.project}-be-bucket"

  tags = merge({ Name = "${var.project}-be-bucket" }, local.tags)
}

resource "aws_s3_bucket_acl" "be_acl" {
  bucket = aws_s3_bucket.be_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "be_versioning" {
  bucket = aws_s3_bucket.be_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_kms_key" "be_key" {
  description = "This key is used to encrypt objects in be bucket"
  tags        = merge({ Name = "${var.project}-be-key" }, local.tags)
}

resource "aws_s3_bucket_server_side_encryption_configuration" "be_encryption_config" {
  bucket = aws_s3_bucket.be_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.be_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
