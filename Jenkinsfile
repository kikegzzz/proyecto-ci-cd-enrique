pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'kikegzzz' // Asegúrate de que este es tu usuario
        APP_NAME = 'proyecto-ci-cd-enrique'
        IMAGE_TAG = 'latest'
    }

    stages {
        stage('Clone & Workspace Info') {
            steps {
                sh 'ls -la'
            }
        }

        stage('Install dependencies & Test') {
            steps {
                // Instalamos pip y las librerías directamente en el agente
                sh '''
                    apt-get update && apt-get install -y python3-pip
                    pip3 install flask pytest --break-system-packages || pip3 install flask pytest
                    python3 -m pytest test_app.py
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                // Aquí usamos el comando docker del host
                sh "docker build -t ${DOCKERHUB_USER}/${APP_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Login & Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                    sh "docker push ${DOCKERHUB_USER}/${APP_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    kubectl apply -f deployment.yaml
                    kubectl apply -f service.yaml
                    kubectl rollout restart deployment proyecto-ci-cd-enrique || echo "Primer despliegue"
                '''
            }
        }
    }

    post {
        failure { echo 'Pipeline fallido' }
        success { echo '¡Pipeline finalizado con éxito!' }
    }
}
