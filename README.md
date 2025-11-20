####################################
How to Deploy Terraform Envoronments
####################################

Pre-requisites:
==============
1. For storing the backend, we are using an S3 bucket and a DynamoDB table.
Before running the Terraform code, please make sure the following are created in your AWS account:

S3 bucket: kullu-eks-tf-state
DynamoDB table: kullu-eks-tf-lock

2. Configure your AWS account on your local machine before running the Terraform code. Use the following commands:

aws configure --profile='kullu'
This command will ask for:
AWS Access Key
AWS Secret Access Key
AWS Region
Output format: json
## Set the profile: ###
export AWS_PROFILE='kullu'
## Verify the configuration:##
aws sts get-caller-identity

3. Apply the terroform now.
###################
#      Dev      #
###################
terraform init -reconfigure -backend-config=dev.tfbackend
terraform plan -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars -auto-approve
terraform destroy -var-file=dev.tfvars -auto-approve

###################
#      Stage      #
###################
terraform init -reconfigure -backend-config=stage.tfbackend
terraform plan -var-file=stage.tfvars
terraform apply -var-file=stage.tfvars -auto-approve
terraform destroy -var-file=stage.tfvars -auto-approve

###################
#      Prod      #
###################
terraform init -reconfigure -backend-config=prod.tfbackend
terraform plan -var-file=prod.tfvars
terraform apply -var-file=prod.tfvars -auto-approve
terraform destroy -var-file=prod.tfvars -auto-approve

4. Once terraform apply done you can configure the cluster into your local by following this commands
# get the cluster name
aws eks list-clusetrs --region <AWS_Region>
# connect the cluster
aws eks update-kubeconfig --region <AWS_Region> --name <cluster_name>
# verify the connectivity
kubectl config current-context
5. After this in AWS EKS we have to add few addons to the cluster.
   EBS-CSI driver
   EFS-CSI driver
   VPC-CNI
   kube-proxy
   Metric-server
6. Verify the pods in kube-system name space. We can also add these addons in our terraform scripts as well if required.   

######################################
Install Litmus Open Source Application
######################################
Steps:
=====
1. Create namespace litmus
2. Create Storage class
3. helm repo add litmuschaos https://litmuschaos.github.io/litmus-helm/
4. helm repo update
5. helm install chaos litmuschaos/litmus   
  --namespace litmus   
  --set portal.frontend.service.type=NodePort   
  --set mongodb.persistence.storageClass=gp2-wait   
  --set mongodb.persistence.size=1Gi   
  --set mongodb.persistence.accessModes[0]=ReadWriteOnce
7. kubectl get po -n litmus
8. kubectl get svc -n litmus  
9. To access portal from browser so the port forward with below command:
   kubectl port-forward -n litmus svc/chaos-litmus-frontend-service 9091:9091
10. Initial uname password is admin\litmus.  

10. trouble shooting
====================
Steps to fix
Run:
kubectl edit configmap subscriber-config -n litmus
Find the line:
SERVER_ADDR: http://localhost:9091/api/query
Replace it with:
SERVER_ADDR: http://chaos-litmus-frontend-service.litmus.svc.cluster.local:9091/api/query

######################################
Install kube-prometheus-stack Grafana
######################################
1. Create name space (kubectl create ns monitoring)
2. Go to monitoring --> kube-promethesu-stack directory
3. Execute install.sh file
4. sh install.sh
5. To access the grafana port-forward thegrafana service
   kubectl port-forward svc/kube-prometheus-stack-grafana 3000:80 -n monitoring

#############################
Install Cluster Auto Scaler
#############################
1. Go to kube-system\cluster-autoscaler
2. Apply service-account.yml
3. Apply configmap.yml
4. Apply rbc.yml
5. Apply cluster-autoscaler.yml.

############################################
Install sock-shop micro service applications
############################################
1. Go to microservices-demo\deploy\kubernetes
2. Apply complete-demo.yaml fil
3. kubectl apply -f complete-demo.yaml
4. Verify the pods are up and running or not
   kubectl get po -n sock-shop
5. To access the front end application on browser port forward the front-end service
  kubectl get svc -n sock-shop
  kubectl port-forward svc/front-end 8080:80 -n sock-shop.

##################################
Apply HPA to front-end application
##################################
1. Go to hpa\
2. Apply front-end.yml (kubectl apply -f front-end.yml)
3. Verify the pod replica count.
   kubectl get po -n sock-shop | grep front-end