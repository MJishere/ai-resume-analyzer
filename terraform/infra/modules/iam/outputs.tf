output "eks_cluster_role_arn" {
  description = "ARN of the EKS Cluster IAM Role"
  value       = aws_iam_role.eks_cluster.arn
}

output "eks_node_group_role_arn" {
  description = "ARN of the EKS Node Group IAM Role"
  value       = aws_iam_role.eks_node_group.arn
}