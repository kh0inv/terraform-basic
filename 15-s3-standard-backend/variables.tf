variable "region" {
  type = string
}

variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "principal_arns" {
  description = "A list of principal arns allowed to assume the IAM role"
  default     = null
  type        = list(string)
}
