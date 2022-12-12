provider "aws" {
  region = var.region
}

locals {
  tags = {
    Project     = var.project
    Environment = var.env
  }
}

resource "aws_resourcegroups_group" "be_group" {
  name = "${var.project}-be-group"

  resource_query {
    query = jsonencode({
      ResourceTypeFilters = ["AWS::AllSupported"]
      TagFilters = [
        {
          Key    = "Project"
          Values = ["${var.project}"]
        }
      ]
    })
  }

  tags = merge({ Name = "${var.project}-be-group" }, local.tags)
}

output "config" {
  value = {
    bucket         = aws_s3_bucket.be_bucket.bucket
    region         = var.region
    role_arn       = aws_iam_role.be_role.arn
    dynamodb_table = aws_dynamodb_table.be_table.name
  }
}
