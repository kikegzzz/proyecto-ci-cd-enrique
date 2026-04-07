pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "kikegzzz/proyecto-ci-cd-enrique"
    }

    stages {

        stage('Clone') {
            steps {
                git 'https://github.com/kikegzzz/proyecto-ci-cd-tu_nombre.git'
            }
        }

        stage('Install dependencies & Test') {
            steps {
                sh '''
                pip install flask pytest
                pytest
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Login DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh 'docker push $DOCKER_IMAGE'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                kubectl apply -f deployment.yaml
                kubectl apply -f service.yaml
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline completado correctamente'
        }
        failure {
            echo 'Pipeline fallido'
        }
    }
}
