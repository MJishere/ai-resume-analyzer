variable "project_name" {
  description = "Project name"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for EKS"
  type        = list(string)
}

variable "eks_cluster_role_arn" {
  description = "EKS Cluster IAM role arn"
  type        = string
}

variable "eks_node_group_role_arn" {
  description = "EKS Node Group IAM Role ARN"
  type        = string
}