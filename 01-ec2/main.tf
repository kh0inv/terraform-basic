provider "aws" {
  region = "us-east-1"
}

/*
Provides an EC2 instance resource
Passing arguments: ami, instance type, tags
*/
resource "aws_instance" "hello" {
  ami           = "ami-0574da719dca65348"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}
