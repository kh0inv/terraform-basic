resource "aws_dynamodb_table" "be_table" {
  name = "${var.project}-be-table"

  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge({ Name = "${var.project}-be-table" }, local.tags)
}
