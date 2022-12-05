provider "aws" {
  region = "us-east-1"
}

# Get the ID of a registered AMI for use in other resources
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] #Canonical Ubuntu AWS account id

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# Get details about a specific S3 bucket
data "aws_s3_bucket" "stag-bucket-data" {
  bucket = "sw-website-prod"
}

# Create new instance
resource "aws_instance" "hello" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}
