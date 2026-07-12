#!/bin/bash

set -euo pipefail

echo "Getting VPC ID..."

VPC_ID=$(aws eks describe-cluster \
    --name "$EKS_CLUSTER" \
    --region "$AWS_REGION" \
    --query "cluster.resourcesVpcConfig.vpcId" \
    --output text)

echo "Getting AWS Account ID...."

ACCOUNT_ID=$(aws sts get-caller-identity \
    --query Account \
    --output text)

ROLE_ARN="arn:aws:iam::${ACCOUNT_ID}:role/ai-resume-analyzer-aws-load-balancer-controller-role"

echo "Installing AWS Load Balancer Controller....."

helm upgrade --install aws-load-balancer-controller \
    eks/aws-load-balancer-controller \
    --namespace kube-system \
    --create-namespace \
    --wait \
    --version 3.4.1 \
    --set clusterName="$EKS_CLUSTER" \
    --set region="$AWS_REGION" \
    --set vpcId="$VPC_ID" \
    --set serviceAccount.create=true \
    --set serviceAccount.name=aws-load-balancer-controller \
    --set-string serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn="$ROLE_ARN"

echo "AWS Load Balancer Controller installed successfully."