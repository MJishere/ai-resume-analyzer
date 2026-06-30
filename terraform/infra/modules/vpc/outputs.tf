output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "Public Subnet IDs"
  value       = values(aws_subnet.public)[*].id
}

output "private_subnet_ids" {
  description = "Private Subnet IDs"
  value       = values(aws_subnet.private)[*].id
}