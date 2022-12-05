provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# terraform apply -var-file="production.tfvars"
resource "aws_instance" "hello" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  tags = {
    name = "HelloWorld"
  }
}
