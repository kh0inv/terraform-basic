data "aws_caller_identity" "current" {}

locals {
  principal_arns = var.principal_arns != null ? var.principal_arns : [data.aws_caller_identity.current.arn]
}

resource "aws_iam_role" "be_role" {
  name = "${var.project}-be-role"
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
    name = "${var.project}-be-policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = "s3:ListBucket"
          Resource = "${aws_s3_bucket.be_bucket.arn}"
        },
        {
          Effect = "Allow"
          Action = [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject"
          ]
          Resource = "${aws_s3_bucket.be_bucket.arn}/*"
        },
        {
          Effect = "Allow"
          Action = [
            "dynamodb:GetItem",
            "dynamodb:PutItem",
            "dynamodb:DeleteItem"
          ]
          Resource = "${aws_dynamodb_table.be_table.arn}"
        }
      ]
    })
  }

  tags = merge({ Name = "${var.project}-be-role" }, local.tags)
}
