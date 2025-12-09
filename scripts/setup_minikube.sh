#!/bin/bash

set -e

echo "=== Installing Minikube ==="
# For Linux
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
install minikube-linux-amd64 /usr/local/bin/minikube

echo "=== Installing kubectl ==="
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install kubectl /usr/local/bin/kubectl

echo "=== Starting Minikube cluster ==="
minikube start --driver=docker

echo "=== Setting Docker ENV to Minikube ==="
eval $(minikube docker-env)

echo "Minikube setup complete!"