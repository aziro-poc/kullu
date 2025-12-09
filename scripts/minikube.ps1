# Must be run as Administrator
Write-Host "=== Installing Minikube for Windows ==="

# Download Minikube
Invoke-WebRequest -Uri "https://storage.googleapis.com/minikube/releases/latest/minikube-windows-amd64.exe" -OutFile "minikube.exe"
Move-Item -Path "minikube.exe" -Destination "C:\Windows\System32\minikube.exe" -Force

Write-Host "=== Installing kubectl ==="
$kubectlVersion = Invoke-RestMethod -Uri "https://dl.k8s.io/release/stable.txt"
Invoke-WebRequest -Uri "https://dl.k8s.io/release/$kubectlVersion/bin/windows/amd64/kubectl.exe" -OutFile "kubectl.exe"
Move-Item -Path "kubectl.exe" -Destination "C:\Windows\System32\kubectl.exe" -Force

Write-Host "=== Starting Minikube with Docker driver ==="
minikube start --driver=docker

Write-Host "=== Setting Docker ENV to Minikube ==="
minikube docker-env | Invoke-Expression

Write-Host "Minikube setup complete!"