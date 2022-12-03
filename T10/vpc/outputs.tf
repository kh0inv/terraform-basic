output "gateway_address" {
  value = aws_internet_gateway.gw.id
  description = "gateway address"
}

output "private_subnet" {
  value = aws_subnet.private_subnet.id
  description = "private subnet"
}

output "public_subnet" {
  value = aws_subnet.public_subnet.id
  description = "public subnet"
}
