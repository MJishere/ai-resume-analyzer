output "public_ip" {
  value = aws_instance.jenkins_server.public_ip
}

output "public_dns" {
  value = aws_instance.jenkins_server.public_dns
}

output "public_eip" {
  value = aws_eip.jenkins_eip.public_ip
}


############## Terraform backe resource output ########
output "terraform_state_bucket_name" {
  description = "S3 bucket used for Terraform remote state"
  value       = aws_s3_bucket.terraform_state_bucket.bucket
}

output "terraform_state_lock_table_name" {
  description = "DynamoDB table used for Terraform state locking"
  value       = aws_dynamodb_table.terraform_state_lock.name
}