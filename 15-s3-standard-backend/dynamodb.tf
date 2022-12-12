resource "aws_dynamodb_table" "backend_table" {
  name         = "${var.project}-backend-table"

  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge({ Name = "${var.project}-backend-table" }, local.tags)
}
