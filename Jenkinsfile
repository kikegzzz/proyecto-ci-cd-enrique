pipeline {
    agent any

    environment {
        // REEMPLAZA ESTO CON TU USUARIO REAL DE DOCKERHUB
        DOCKERHUB_USER = 'kikegzzz'
        APP_NAME = 'proyecto-ci-cd-enrique'
        IMAGE_TAG = 'latest'
    }

    stages {
        stage('Clone & Workspace Info') {
            steps {
                // El checkout ya se hace automáticamente por Jenkins SCM
                sh 'ls -la'
                echo "Rama actual: ${env.BRANCH_NAME}"
            }
        }

        stage('Install dependencies & Test') {
    agent {
        docker { image 'python:3.9-slim' }
    }
    steps {
        sh '''
            pip install flask pytest
            python -m pytest test_app.py
        '''
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
                // Asegúrate de que Minikube esté corriendo en el host
                sh '''
                    kubectl apply -f deployment.yaml
                    kubectl apply -f service.yaml
                    kubectl rollout restart deployment proyecto-ci-cd-enrique || echo "Primer despliegue"
                '''
            }
        }
    }

    post {
        success {
            echo '¡Pipeline finalizado con éxito! La imagen está en DockerHub y desplegada en K8s.'
        }
        failure {
            echo 'El Pipeline ha fallado. Revisa los logs de la etapa que falló.'
        }
    }
}
