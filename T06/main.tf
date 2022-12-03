provider "aws" {
  region = "us-west-2"
}

data "aws_instance" "ubuntu" {
  most_recent = true
  owners = ["099720109477"]
  filter {
    name = "name"
    values = [ "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*" ]
  }
}

variable "instance_type" {
  type = string
  description = "Instance type of EC2"
  validation {
    condition = contains(["t2.micro", "t3.small"], var.instance_type)
    error_message = "Value not allow"
  }
}

resource "aws_instance" "hello" {
  count = 5
  ami = data.aws_instance.ubuntu.id
  instance_type = var.instance_type
  tags = {
    name = "HelloWorld"
  }
}

output "ec2" {
  value = {
    public_ip = [ for v in aws_instance.hello.public_ip: v.public_ip ]
  }
}
