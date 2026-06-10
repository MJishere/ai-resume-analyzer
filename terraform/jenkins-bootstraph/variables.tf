variable "aws_region" {
  description = "AWS region for jenkins server"
  type        = string
  default     = "us-east-1"
}

variable "key_name" {
  description = "EC2 Key pair name"
  type        = string
}