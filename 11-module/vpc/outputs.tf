output "gateway_address" {
  description = "gateway address"
  value = aws_internet_gateway.gw.id
}

output "private_subnets" {
  description = "private subnet"
  value = {
    private_subnet_id = [for v in aws_subnet.private_subnet : v.id]
  }
}

output "public_subnets" {
  description = "public subnet"
  value = [for v in aws_subnet.public_subnet : v.id]
}
