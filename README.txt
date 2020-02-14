PHP Application with 2 ReplicaSets connecting to mysql db with 1 replicaset exposing LoadBalancer URL
*****************************************************************************************************
# 1. Create and Display namespace(webapp-namespace, database-namespace)

kubectl apply -f namespace-phpapp.yml
kubectl apply -f namespace-mysql.yml
kubectl get ns

*******************************************************************
# 2. Generate base64 Password and Run Secret.yml file and display

echo -n "Pr@123veen" | base64
kubectl apply -f secret.yml
kubectl get secret -n database-namespace
kubectl describe secret mysql-secrets -n database-namespace

*******************************************************************
# 3. Create Persistent Storage and display

kubectl apply -f persistentVolumeClaim.yml
kubectl get pvc -n database-namespace

*******************************************************************
# 4. Deploy PHP application and mysql

kubectl apply -f deployment-phpapp.yaml
kubectl get deployments -n webapp-namespace

kubectl apply -f deployment-mysql.yaml
kubectl get deployments -n database-namespace

kubectl get pods -n database-namespace -o wide

*******************************************************************
# 5. Service to Run

kubectl apply -f service-phpapp.yaml
kubectl get service -n webapp-namespace

kubectl apply -f service-mysql.yaml
kubectl get service -n database-namespace

kubectl get nodes

kubectl get pods -n webapp-namespace
kubectl get pods -n webapp-namespace -o wide

kubectl get pods -n database-namespace
kubectl get pods -n database-namespace -o wide

kubectl get events -n webapp-namespace
kubectl describe node ip-10-1-63-58.ap-south-1.compute.internal
kubectl describe pod mysql-deployment-5b64589fb7-4cp7b -n database-namespace

kubectl logs -f mysql-deployment-5b64589fb7-ncdss -n database-namespace
kubectl exec -it mysql-deployment-5b64589fb7-ncdss -n database-namespace -- /bin/bash
kubectl exec -it phpapp-8587d8756d-j2jhz -n webapp-namespace -- /bin/bash

*******************************************************************
# 6. Testing: Scale UP

kubectl scale deployment phpapp-deployment -n webapp-namespace --replicas=3
kubectl get deploy
kubectl get po -o wide

*******************************************************************
# 7. Testing: Scale DOWN

kubectl scale deployment phpapp-deployment -n webapp-namespace --replicas=1
kubectl get deploy
kubectl get po -o wide
   
*******************************************************************