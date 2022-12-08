output "vpc" {
  value = module.vpc
}

output "security_groups" {
  value = {
    bastion = aws_security_group.bastion_sg.id
    web     = aws_security_group.web_sg.id
    lb      = aws_security_group.lb_sg.id
    db      = aws_security_group.db_sg.id
  }
}

output "db_subnet_group" {
  value = aws_db_subnet_group.db_subnet_group
}
