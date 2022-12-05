output "ec2_private_ip_addr" {
  description = "The private IP address of the main server instance"
  value = aws_instance.hello.private_ip
}

output "ec2_ip_addr" {
  description = "The public IP address of the main server instance"

  value = {
    public_ip = aws_instance.hello.public_ip
    private_ip = aws_instance.hello.public_ip
  }
}
