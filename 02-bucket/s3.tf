provider "aws" {
  region = "us-east-1"
}

/*
Provides a S3 bucket resource
Passing arguments: bucket name, tags
*/
resource "aws_s3_bucket" "terraform-bucket-14363" {
  bucket = "terraform-series-bucket-3546363"

  tags = {
    Name = "Terraform Series"
  }
}
