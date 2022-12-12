data "aws_caller_identity" "current" {}

locals {
  principal_arns = var.principal_arns != null ? var.principal_arns : [data.aws_caller_identity.current.arn]
}

resource "aws_iam_role" "backend_role" {
  name = "${var.project}-backend-role"
  path = "/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          AWS = local.principal_arns
        }
      },
    ]
  })

  inline_policy {
    name = "${var.project}-backend-policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = "s3:ListBucket"
          Resource = "${aws_s3_bucket.backend_bucket.arn}"
        },
        {
          Effect   = "Allow"
          Action   = [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject"
          ]
          Resource = "${aws_s3_bucket.backend_bucket.arn}/*"
        },
        {
          Effect   = "Allow"
          Action   = [
            "dynamodb:GetItem",
            "dynamodb:PutItem",
            "dynamodb:DeleteItem"
          ]
          Resource = "${aws_dynamodb_table.backend_table.arn}"
        }
      ]
    })
  }

  tags = merge({ Name = "${var.project}-backend-role" }, local.tags)
}
