resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = "custom"
  }
}

resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_ip)
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.private_subnet_ip[count.index]
  availability_zone = var.availability_zone[count.index % length(var.availability_zone)]

  tags = {
    Name = "private-subnet"
  }
}

resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_ip)
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet_ip[count.index]
  availability_zone = var.availability_zone[count.index % length(var.availability_zone)]

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "custom"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "public_router" {
  for_each       = { for k, v in aws_subnet.public_subnet : k => v }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "eip" {
  vpc = true
}

resource "aws_nat_gateway" "public" {
  subnet_id = aws_subnet.private_subnet[0].id
  allocation_id = aws_eip.eip.id
  tags = {
    "name" = "nat"
  }
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.public.id
  }
  tags = {
    "name" = "private"
  }
}

resource "aws_route_table_association" "private_router" {
  for_each = { for k, v in aws_subnet.private_subnet: k => v }
  subnet_id =  each.value.id
  route_table_id = aws_route_table.private.id
}
