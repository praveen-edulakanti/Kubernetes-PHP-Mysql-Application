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
   }    
}


def getDockerTag(){
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}