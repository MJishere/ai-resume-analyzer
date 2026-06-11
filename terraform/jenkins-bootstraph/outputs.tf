output "public_ip" {
  value = aws_instance.jenkins_server.public_ip
}

output "public_dns" {
  value = aws_instance.jenkins_server.public_dns
}

output "public_eip" {
  value = aws_eip.jenkins_eip.public_ip
}

output "ebs_volume_id" {
  value = aws_ebs_volume.jenkins_data.id
}