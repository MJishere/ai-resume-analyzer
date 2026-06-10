output "public_ip" {
  value = aws_instance.jenkins_server.public_ip
}

output "public_dns" {
  value = aws_instance.jenkins_server.public_dns
}

output "instance_id" {
  value = aws_instance.jenkins_server.id
}

output "ebs_volume_id" {
  value = aws_ebs_volume.jenkins_data.id
}