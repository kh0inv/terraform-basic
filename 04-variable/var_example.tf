variable "instance_type" {
  description = "Instance type of the EC2"
  type        = string

  validation {
    condition     = contains(["t2.micro", "t3.small"], var.instance_type)
    error_message = "Value not allow"
  }
}
