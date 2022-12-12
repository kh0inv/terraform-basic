provider "aws" {
  region = var.region
}

locals {
  tags = {
    Project     = var.project
    Environment = var.env
  }
}

resource "aws_resourcegroups_group" "resourcegroups_group" {
  name = "${var.project}-s3-backend"

  resource_query {
    # query = <<-JSON
    #   {
    #     "ResourceTypeFilters": [
    #       "AWS::AllSupported"
    #     ],
    #     "TagFilters": [
    #       {
    #         "Key": "project",
    #         "Values": ["${var.project}"]
    #       }
    #     ]
    #   }
    # JSON
    query = jsonencode({
      ResourceTypeFilters = ["AWS::AllSupported"]
      TagFilters = [
        {
          Key = "Project"
          Values = ["${var.project}"]
        }
      ]
    })
  }
}

