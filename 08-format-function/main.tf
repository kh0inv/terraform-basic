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

resource "aws_instance" "hello" {
  count         = 3
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}

# Use for expressions to create map of public ip, with key replace by format() function
output "ec2_public_ip" {
  description = "Map of public IP address"
  value = { for i, v in aws_instance.hello : format("public_ip%d", i + 1) => v.public_ip }
}
