pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'kikegzzz' 
        APP_NAME = 'proyecto-ci-cd-enrique'
        IMAGE_TAG = 'latest'
    }

    stages {
        stage('Clone & Workspace Info') {
            steps {
                sh 'ls -la'
            }
        }

        stage('Build & Test') {
            steps {
                // Construimos la imagen localmente para testearla
                sh "docker build -t ${APP_NAME}-test ."
                
                // Ejecutamos los tests DENTRO del contenedor que acabamos de crear
                sh "docker run --rm ${APP_NAME}-test python3 -m pytest test_app.py"
            }
        }

        stage('Login & Push to DockerHub') {
            steps {
                sh "docker tag ${APP_NAME}-test ${DOCKERHUB_USER}/${APP_NAME}:${IMAGE_TAG}"
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                    sh "docker push ${DOCKERHUB_USER}/${APP_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
		script {
            // Forzamos la IP del host y el puerto del proxy directamente en el comando
            sh "kubectl --server=http://172.17.0.1:8001 apply -f deployment.yaml --validate=false"
            sh "kubectl --server=http://172.17.0.1:8001 apply -f service.yaml --validate=false"
            sh "kubectl --server=http://172.17.0.1:8001 rollout restart deployment proyecto-ci-cd-enrique"
            }
        }
    }
}
    post {
        success { echo '¡Pipeline finalizado con éxito!' }
        failure { echo 'Pipeline fallido' }
    }
}
