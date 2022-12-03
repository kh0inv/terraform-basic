provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "hello" {
  ami           = "ami-0574da719dca65348"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}
