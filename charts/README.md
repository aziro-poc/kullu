I. Setup Minikube locally:
1. We have creaed the following sh file for installing the minikube locally.
   scripts\setup_minikube.ps1
2. After installing it follow hte below steps to setup docker env in minikube as env path
  minikube start
  minikube docker-env
  & minikube -p minikube docker-env | Invoke-Expression
3. Verify the Dockcker  
docker images
4. Try to verify the cluster connectivity
   minikube status
   minikube ip
   kubectl get nodes

II. Jenkins Setup:
1. For CI & CD we used jenkins which is deployed out side the minikube cluster. As of now it is running as local application. In future we will have one dedicated server for jenkins.
2. Using jenking we are doing the folllowing steps
   i. Code Checkout
   ii. Building the golang application\
   iii. Creating the Docker image
   vi. Pushing the Docker image to Artifacts repo (dockerhub)
   v. Deploy to kubernetes.

III. Helm Charts
1. We have created the Helm charts for each of the applicaion (go-app & postgress)
2. We have separate helm charts for go-app and postgress. Each chart have their own deployment.yml file.
3. We have created the configmap for storing the sensitive data whithout exposing them into application files. In future we will be have AWS Secret Manager to store all the sensitive data over there.
4. These helm charts help to keep track and revert back the application if something goes wrong using Rollout upgrades.

IV. Database
1. We used postgres as a application database.
2. This is also deployed as helm chart deployment. If we want to make this high availability we have to deploy this as a Stateful Set.
3. We have give the connection between database and go application within the go-app values.yml and deployment.yml file.

V. Endpoints
1. As part of devloping the Go application we have added few endpoints for the application which can be accessble via API calls
2. For Health check we have one ping which can ive the responce as pong (ex: http://10.60.2.44:8080/ping)
3. These endpoints can be tested with Postman pplication.

VI.
1. For observebility we are using the Kube-prometheus-stack along with Grafana. This is also been deployed as a helm charts.
2. We are able to access the application metic logs and cluster metric logs as well in Grafan.
