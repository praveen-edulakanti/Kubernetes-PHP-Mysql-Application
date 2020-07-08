pipeline {
    agent any
    environment{
        COMMIT_ID = getLatestCommitId()
        DOCKER_URL = "praveenedulakanti"
        IMAGE_URL_WITH_TAG = "${DOCKER_URL}/phpapp-devops:${BUILD_NUMBER}"
        DOCKER_USER_NAME = "praveenedulakanti"
    }
    stages {
        stage('CleanWorkspace') {
            steps {
                sh 'echo ${WORKSPACE}'
                sh 'echo ${COMMIT_ID}'
                sh 'echo ${BUILD_NUMBER}'
                cleanWs()
            }
        }
        stage('k8s Code Pull'){
            steps {
                git url: 'https://github.com/praveen-edulakanti/Kubernetes-PHP-Mysql-Application.git'
            }
        }
        stage('Remove All Old Docker Images') {
            steps {
			    sh 'docker rmi $(docker images -q) --force'
			}
		}
        stage('Build Docker Image') {
            steps {
		   sh 'docker build -t $IMAGE_URL_WITH_TAG .'
		  }
		}
	 stage('Push Docker Image'){
 	     steps { 
		    withCredentials([string(credentialsId: 'DOCKER_HUB_PASSWORD', variable: 'DOCKER_HUB_PASSWORD')]) {
                    sh '''
                 	docker login --username=$DOCKER_USER_NAME --password=$DOCKER_HUB_PASSWORD
                 	docker push $IMAGE_URL_WITH_TAG
	               '''      
         	      }
	           }
		}
	 stage("Assign BuildNumber to k8s"){
	     steps {
	            sh 'chmod +x changeBuildNumber.sh'
                    sh './changeBuildNumber.sh $BUILD_NUMBER'
	     }
	 }   
	 stage("Deploy To Kubernetes Cluster"){
	     steps {
                   sh '''kubectl apply -f namespace-phpapp.yml
		         kubectl apply -f namespace-mysql.yml
		         kubectl apply -f secret.yml
		         kubectl apply -f mysql-secret-env.yaml
		         kubectl apply -f storage.yaml
			 kubectl apply -f persistentVolumeClaim.yml
			 kubectl apply -f deployment-phpapp-buildno.yaml
			 kubectl apply -f deployment-mysql.yaml
			 kubectl apply -f service-phpapp.yaml
			 kubectl apply -f service-mysql.yaml
			 echo "****** Load Balancer URL******"
			 kubectl get service -n webapp-namespace
			 echo "MYSQL DATABASE CREATE if not exist"
			 export MYSQLPOD=$(kubectl get pods -n database-namespace -l app=mysql --no-headers | awk '{print $1}')
			 kubectl exec -n database-namespace -ti $MYSQLPOD -- mysql --user=root --password=Pr@123veen < mysqldump.sql
                      '''
		   }
        } 
    }
}

def getLatestCommitId(){
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}
