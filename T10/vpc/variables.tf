variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "private_subnet_ip" {
  type = list(string)
}

variable "public_subnet_ip" {
  type = list(string)
}

variable "availability_zone" {
  type = list(string)
}
