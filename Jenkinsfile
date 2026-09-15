pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
            }
        }

        stage('Build Docker Images') {
            steps {
                sh '''
                    docker build -t three-tier-backend:latest ./Application-Code/backend
                    docker build -t three-tier-frontend:latest ./Application-Code/frontend
                '''
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying to EKS...'
            }
        }
    }
}