pipeline {
    agent any
    environment{
        COMMIT_ID = getLatestCommitId()
    }
    stages {
        stage('CleanWorkspace') {
            steps {
                sh 'echo ${WORKSPACE}'
                sh 'echo ${COMMIT_ID}'
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
			    sh 'docker build -t praveenedulakanti/phpapp-devops:$BUILD_NUMBER .'
			}
		}
		stage('Push Docker Image'){
		    steps { 
			    withCredentials([string(credentialsId: 'DOCKER_HUB_PASSWORD', variable: 'DOCKER_HUB_PASSWORD')]) {
                sh 'docker push praveenedulakanti/phpapp-devops'
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
                   '''
		   }
        } 
    }
}


def getLatestCommitId(){
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}