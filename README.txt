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

Generated env variable to access from application

kubectl apply -f mysql-secret-env.yaml
kubectl get secret -n webapp-namespace
kubectl describe secret mysql-secret-env -n webapp-namespace

*******************************************************************
# 3. Create StorageClass, Persistent Storage and display

kubectl apply -f storage.yaml
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

MYSQL Connecting for database to create and table
export MYSQLPOD=$(kubectl get pods -n database-namespace -l app=mysql --no-headers | awk '{print $1}')
kubectl logs -n database-namespace $MYSQLPOD

kubectl exec -n database-namespace -ti $MYSQLPOD -- mysql --user=root --password=Pr@123veen
run mysqldump.sql file in mysql terminal
  or
kubectl exec -n database-namespace -ti $MYSQLPOD -- mysql --user=root --password=Pr@123veen < /path/mysqldump.sql


kubectl describe node ip-10-1-63-58.ap-south-1.compute.internal
kubectl describe pod mysql-deployment-5b64589fb7-4cp7b -n database-namespace
kubectl describe pod phpapp-deployment-78445cd9c-sfdsf -n webapp-namespace

kubectl logs -f mysql-deployment-5b64589fb7-ncdss -n database-namespace
kubectl exec -it mysql-deployment-5b64589fb7-ncdss -n database-namespace -- /bin/bash
kubectl exec -it phpapp-8587d8756d-j2jhz -n webapp-namespace -- /bin/bash

*******************************************************************
# 6. Setup Elastic Search, fluentd, kibana

kubectl apply -f fluentd-config.yaml
kubectl apply -f elastic-stack.yaml 

kubectl logs -f statefulset.apps/elasticsearch-logging -n kube-system
kubectl get all -n kube-system
kubectl get all -n kube-system -o wide
kubectl get po -n kube-system -o wide
kubectl get po -n kube-system
kubectl get svc -n kube-system
kubectl describe svc kibana-logging -n kube-system

kibana load balancer url connects with port number, need to check in Load Balancer

*******************************************************************
# 7. Testing: Scale UP

kubectl scale deployment phpapp-deployment -n webapp-namespace --replicas=3
kubectl get deploy
kubectl get po -o wide

*******************************************************************
# 8. Testing: Scale DOWN

kubectl scale deployment phpapp-deployment -n webapp-namespace --replicas=1
kubectl get deploy
kubectl get po -o wide

*******************************************************************
 # 9. Rollout Concept
	Check the rollout status
kubectl rollout status deploy phpapp-deployment -n webapp-namespace

  Change Image url to new Release number in deployment-phpapp.yaml
kubectl apply -f deployment-phpapp.yaml

 Read the deployment history(current and previous)
kubectl rollout history deploy phpapp-deployment -n webapp-namespace
  
  Rolling Back to a Previous Revision
kubectl rollout undo deploy phpapp-deployment -n webapp-namespace
     or 
kubectl rollout undo deploy phpapp-deployment –-to—revision=1 -n webapp-namespace (previous revision no..)

*******************************************************************
   Misc Commands for debug:
kubectl get all -n kube-system -o wide
kubectl exec -it mysql-deployment-5b68bb45bc-lv2np -n database-namespace /bin/bash
kubectl get po -n database-namespace -o wide


