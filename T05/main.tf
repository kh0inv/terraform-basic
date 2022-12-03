provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"]
  filter {
    name = "name"
    values = [ "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*" ]
  }
}

# variable "instance_type" {
#   type = string
#   description = "Instance type of the EC2"
# }

resource "aws_instance" "hello" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  tags = {
    name = "HelloWorld"
  }
}

