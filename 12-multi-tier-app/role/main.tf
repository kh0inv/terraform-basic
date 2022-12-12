variable "project" {
  type = string
}

resource "aws_iam_role" "ec2_instance_role" {
  name = "${var.project}-ec2-instance-role"

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
    name = "${var.project}-ec2-instance-policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = ["s3:*"]
          Resource = "*"
        }
      ]
    })
  }

  tags = {
    Name        = "${var.project}-ec2-instance-role"
    Project     = "${var.project}"
    Environment = "prod"
  }
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.project}-ec2-instance-profile"
  role = aws_iam_role.ec2_instance_role.name
}

output "ec2_instance_profile" {
  value = aws_iam_instance_profile.ec2_instance_profile
}
