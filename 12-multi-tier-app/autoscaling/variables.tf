variable "project" {
  type = string
}

variable "vpc" {
  type = any
}

variable "security_groups" {
  description = "groups of security, contains web security group"
  type        = any
}

variable "key_name" {
  description = "key pair"
  type        = string
}

variable "web_instance_profile_arn" {
  type = any
}
