pipeline {
    agent any
    environment{
        DOCKER_TAG = getDockerTag()
    }
    stages {
        stage('CleanWorkspace') {
            steps {
                sh 'echo ${WORKSPACE}'
                sh 'echo ${DOCKER_TAG}'
                cleanWs()
            }
        }
		stage('k8s Code Pull'){
           steps {
               git url: 'https://github.com/praveen-edulakanti/Kubernetes-PHP-Mysql-Application.git'
           }
        }
        stage('Build Docker Image') {
           steps {
				sh 'docker build -t praveenedulakanti/phpapp-devops:${DOCKER_TAG} .'
			}
		}
		stage('Push Docker Image'){
		   steps { 
			   withCredentials([string(credentialsId: 'DOCKER_HUB_PASSWORD', variable: 'DOCKER_HUB_PASSWORD')]) {
               sh 'docker build -t praveenedulakanti/phpapp-devops:$BUILD_NUMBER .'
               }
             sh 'docker push praveenedulakanti/phpapp-devops'
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
                     kubectl apply -f deployment-phpapp.yaml
                     kubectl apply -f deployment-mysql.yaml
                     kubectl apply -f service-phpapp.yaml
                     kubectl apply -f service-mysql.yaml
                  '''
		   }
        } 
    }    
}


def getDockerTag(){
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}