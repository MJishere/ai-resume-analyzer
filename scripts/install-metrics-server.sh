#!/bin/bash

set -euo pipefail

echo "========================================"
echo "Installing Metrics Server"
echo "========================================"

helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/ || true
helm repo update

kubectl create namespace kube-system --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install metrics-server \
    metrics-server/metrics-server \
    --namespace kube-system \
    --wait

echo
echo "Verifying Metrics Server..."

kubectl rollout status deployment/metrics-server -n kube-system --timeout=300s

kubectl get pods -n kube-system -l app.kubernetes.io/name=metrics-server

kubectl top nodes
kubectl top pods -A

echo
echo "Metrics Server installed successfully."