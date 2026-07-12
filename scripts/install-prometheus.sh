#!/bin/bash

set -euo pipefail

echo "==============================="
echo "Installing kube-prometheus-stack"
echo "==============================="


helm repo add prometheus-community https://prometheus-community.github.io/helm-charts >/dev/null 2>&1 || true
helm repo update

kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install kube-prometheus-stack \
    prometheus-community/kube-prometheus-stack \
    --namespace monitoring \
    --values helm/kube-prometheus-stack/values.yaml \
    --wait

echo
echo "Installation completed."

echo "Verifying kube-prometheus-stack..."

helm status kube-prometheus-stack -n monitoring

kubectl get pods -n monitoring

kubectl get svc -n monitoring

kubectl get pvc -n monitoring

echo
echo "kube-prometheus-stack verification successful."