module "vpc" {
  source = "./modules/vpc"

  project_name = "ai-resume-analyzer"

  vpc_cidr = "10.0.0.0/16"

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.0.101.0/24",
    "10.0.102.0/24"
  ]
  availability_zones = [
    "us-east-1a",
    "us-east-1b"
  ]
}

# IAM Role for the EKS cluster

module "iam" {
  source       = "./modules/iam"
  project_name = "ai-resume-analyzer"
}

# ECR repository

module "ecr" {
  source = "./modules/ecr"

  project_name = "ai-resume-analyzer"
}

# EKS Cluster

module "eks" {
  source = "./modules/eks"

  project_name            = "ai-resume-analyzer"
  private_subnet_ids      = module.vpc.private_subnet_ids
  eks_cluster_role_arn    = module.iam.eks_cluster_role_arn
  eks_node_group_role_arn = module.iam.eks_node_group_role_arn
}