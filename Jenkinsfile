pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        AWS_ACCOUNT_ID = '772607728035'
        ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        BACKEND_IMAGE = "${ECR_REGISTRY}/three-tier-devsecops/backend"
        FRONTEND_IMAGE = "${ECR_REGISTRY}/three-tier-devsecops/frontend"
    }

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

        stage('Push Images to ECR') {
            steps {
                sh '''
                    aws ecr get-login-password --region "$AWS_REGION" | \
                    docker login --username AWS --password-stdin "$ECR_REGISTRY"

                    docker tag three-tier-backend:latest "$BACKEND_IMAGE:latest"
                    docker tag three-tier-frontend:latest "$FRONTEND_IMAGE:latest"

                    docker push "$BACKEND_IMAGE:latest"
                    docker push "$FRONTEND_IMAGE:latest"
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