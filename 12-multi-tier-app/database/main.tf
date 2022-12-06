resource "aws_db_instance" "database" {
  db_name                = "laravel"
  engine                 = "mysql"
  engine_version         = "8.0"
  identifier             = "${var.project}-db-instance"
  username               = "admin"
  password               = "admin"
  allocated_storage      = 100
  instance_class         = "db.m6g.large"
  db_subnet_group_name   = var.subnet_group.id
  vpc_security_group_ids = [var.security_group.db]

  tags = {
    Name        = "${var.project}-rds"
    Project     = "${var.project}"
    Environment = "prod"
  }
}
