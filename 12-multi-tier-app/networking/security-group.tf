resource "aws_security_group" "bastion_sg" {
  name        = "${var.project}-bastion-sg"
  description = "Enable SSH access from IP of customers/administrator to bastion host"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH access from IP of administrator"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ingress {
  #   description      = "SSH access from IP of administrator"
  #   protocol         = "tcp"
  #   from_port        = 22
  #   to_port          = 22
  #   cidr_blocks      = ["0.0.0.0/0"]
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-bastion-sg"
    Project     = var.project
    Environment = "prod"
  }
}

resource "aws_security_group" "web_sg" {
  name        = "${var.project}-web-sg"
  description = "Enable HTTP access from load balancer, SSH access from bastion to private instances"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "HTTP access from load balancer"
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.lb_sg.id]
  }

  ingress {
    description     = "SSH access from bastion"
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-web-sg"
    Project     = var.project
    Environment = "prod"
  }
}

resource "aws_security_group" "lb_sg" {
  name        = "${var.project}-lb-sg"
  description = "Allows HTTP/HTTPS access from anywhere to load balancer"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP access from anywhere"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPs access from anywhere"
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-lb-sg"
    Project     = var.project
    Environment = "prod"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "${var.project}-db-sg"
  description = "Enable db connection from private instances to DB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "DB connection from private instances to DB"
    protocol        = "tcp"
    from_port       = 3306
    to_port         = 3306
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-db-sg"
    Project     = var.project
    Environment = "prod"
  }
}
