provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "server_sg" {
  name = "server-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "server-sg"
  }
}

resource "aws_instance" "remote-server" {
  instance_type          = "t2.micro"
  ami                    = "ami-0574da719dca65348"
  key_name               = "admin-khoinv-key"
  vpc_security_group_ids = [aws_security_group.server_sg.id]

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y software-properties-common",
      "sudo apt-add-repository --yes --update ppa:ansible/ansible",
      "sudo apt install -y ansible"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("./admin-khoinv-key.pem")
      host        = self.public_ip
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u ubuntu --key-file admin-khoinv-key.pem -T 300 -i '${self.public_ip},', playbook.yaml"
  }

  tags = {
    Name = "remote-server"
  }
}
