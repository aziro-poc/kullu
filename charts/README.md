# Kullu Project - Go Application CI/CD

This repository contains a Go application (`go-app`) along with Helm charts, scripts, and configurations to build, containerize, and deploy it to a Kubernetes cluster. The CI/CD pipeline is managed through Jenkins and Docker Hub.

---

## Table of Contents

1. [Application Overview](#application-overview)  
2. [Local Setup with Minikube](#local-setup-with-minikube)  
3. [CI/CD Pipeline Overview](#cicd-pipeline-overview)  
4. [Build and Run Locally](#build-and-run-locally)  
5. [Deployment to Kubernetes](#deployment-to-kubernetes)  
6. [Infrastructure and Jenkins Setup](#infrastructure-and-jenkins-setup)  
7. [Helm Charts](#helm-charts)  
8. [Database](#database)  
9. [Endpoints](#endpoints)  
10. [Observability](#observability)  

---

## Application Overview

- **Language:** Go  
- **Entry point:** `application/main.go`  
- **Build system:** Go modules (`go.mod`, `go.sum`)  
- **Containerization:** Docker  
- **Deployment:** Kubernetes using Helm charts  

The application is a standalone Go service that can be built and run locally using Go or Docker, and deployed to a Kubernetes cluster.

---

## Local Setup with Minikube

1. We have a PowerShell script to install and setup Minikube locally:  
   `scripts\setup_minikube.ps1`  

2. After installation, follow these steps to configure Docker with Minikube:

```powershell
minikube start
& minikube -p minikube docker-env | Invoke-Expression
docker images
minikube status
minikube ip
kubectl get nodes

---

## CI/CD Pipeline Overview

The Jenkins pipeline (Jenkinsfile) performs the following steps:
1. Checkout Code
2. Pulls the latest code from GitHub (master branch).
3. Build Go Application
4. Runs go mod tidy to download dependencies.
5. Builds the Go executable (go_app.exe on Windows).
5. Build Docker Image
6. Uses the application/Dockerfile to create a Docker image.
7. Tags the image as ${DOCKER_HUB_CREDS_USR}/go-app:${BUILD_NUMBER}.
8. Push Docker Image to Docker Hub
9. Logs into Docker Hub using Jenkins credentials.
10. Pushes the Docker image to the repository.
11. Deploy Using Helm
12. Uses Helm chart charts/go-app-chart/ to deploy the application to Kubernetes.
13. Automatically sets the Docker image repository and tag.

---

## Build and Run Locally

Prerequisites:
1. Go >= 1.20
2. Docker Desktop / Docker Engine
3. Kubernetes cluster (optional for Helm deployment)

Build Go Application
cd application
go mod tidy
go build -o go_app.exe .

## Run with Docker:

docker build -t go-app:latest -f Dockerfile .
docker run -p 8080:8080 go-app:latest

## Deployment to Kubernetes

Set KUBECONFIG
set KUBECONFIG=C:\path\to\kube\config

## Deploy using Helm
helm upgrade --install go-app charts\go-app-chart `
    --set image.repository=<dockerhub-username>/go-app `
    --set image.tag=<build-number>

Verify Deployment
kubectl get pods
kubectl get svc

## Infrastructure and Jenkins Setup

Jenkins is used for CI/CD and is currently running locally.
The pipeline performs the following steps:
1. Code Checkout
2. Go Build
3. Docker Image Build
4. Push Docker Image to Docker Hub
5. Deploy to Kubernetes
6. Helm Charts
7. Helm charts are created for each application (go-app & postgres).
8. Each chart contains its own deployment.yml and configuration files.
9. ConfigMaps are used to store sensitive data without exposing it in code.
10. Future plans include using AWS Secrets Manager.
11. Helm allows rollback and version tracking using helm upgrade and rollouts.

## Database

PostgreSQL is used as the application database.
It is deployed via a Helm chart.
For high availability, it can be deployed as a StatefulSet.
Database connection details are defined in values.yml and deployment.yml.
Endpoints
The Go application exposes API endpoints for testing.
A health check endpoint is available:
http://<app-ip>:8080/ping  => returns "pong"
Endpoints can be tested using Postman or any API client.

## Observability

The project uses kube-prometheus-stack and Grafana for monitoring.
Metrics include application logs and cluster-level metrics.
Grafana dashboards are available for visualizing performance and health.

######################################
Install kube-prometheus-stack Grafana
######################################
1. Create name space (kubectl create ns monitoring)
2. Go to monitoring --> kube-promethesu-stack directory
3. Execute install.sh file
4. sh install.sh
5. To access the grafana port-forward thegrafana service
   kubectl port-forward svc/kube-prometheus-stack-grafana 3000:80 -n monitoring

## Summary

This repository provides a complete CI/CD workflow:
Code → Build → Docker → Push → Kubernetes Deployment
Fully Windows-compatible Jenkins pipeline
Helm charts for easy configuration, deployment, and rollback
Monitoring and observability using Prometheus and Grafana