provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "allow_ssh" {
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion" {
  instance_type   = "t2.micro"
  ami             = "ami-0574da719dca65348"
  key_name        = "admin-khoinv-key"
  security_groups = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "bastion"
  }
}
