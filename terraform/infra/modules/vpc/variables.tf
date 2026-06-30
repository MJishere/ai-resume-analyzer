variable "vpc_cidr" {
  description = "CIDR for the vpc"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR for the public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability Zones"
  type        = list(string)
}

variable "project_name" {
  description = "Project name used for the resources"
  type        = string
}