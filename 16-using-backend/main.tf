terraform {
  backend "s3" {
    bucket         = "mamnon-be-bucket"
    key            = "test-prj"
    region         = "us-east-1"
    encrypt        = true
    role_arn       = "arn:aws:iam::269772303061:role/mamnon-be-role"
    dynamodb_table = "mamnon-be-table"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "server" {
  ami           = "ami-0b0dcb5067f052a63"
  instance_type = "t3.micro"

  tags = {
    Name = "Server"
  }
}

output "public_ip" {
  value = aws_instance.server.public_ip
}
