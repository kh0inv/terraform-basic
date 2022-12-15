variable "region" {
  type    = string
  default = "us-east-1"
}

variable "project" {
  type    = string
  default = "mamnon"
}

resource "aws_cloud9_environment_ec2" "admin" {
  description                 = "Cloud9 environment for admin"
  name                        = "${var.project}-admin-env"
  instance_type               = "t3.micro"
  automatic_stop_time_minutes = 30

  tags = {
    Project = "${var.project}"
  }
}

resource "aws_iam_role" "admin_role" {
  name = "${var.project}-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
        Action = "sts:AssumeRole"
      },
    ]
  })

  inline_policy {
    name = "${var.project}-admin-policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = "*"
          Resource = "*"
        }
      ]
    })
  }

  tags = {
    Name    = "${var.project}-admin-role"
    Project = "${var.project}"
  }
}

resource "aws_iam_instance_profile" "admin_profile" {
  name = "${var.project}-admin-profile"
  role = aws_iam_role.admin_role.name
}

output "cloud9_url" {
  value = "https://${var.region}.console.aws.amazon.com/cloud9/ide/${aws_cloud9_environment_ec2.admin.id}"
}

output "admin_profile_name" {
  value = aws_iam_instance_profile.admin_profile.name
}
