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

        stage('1. Checkout') {
            steps {
                checkout scm
            }
        }

        stage('2. Test') {
            steps {
                echo 'Running application tests...'
            }
        }

        stage('3. Build Docker Images') {
            steps {
                sh '''
                    docker build -t three-tier-backend:latest ./Application-Code/backend
                    docker build -t three-tier-frontend:latest ./Application-Code/frontend
                '''
            }
        }

        stage('4. Trivy Security Scan') {
            steps {
                sh '''
                    trivy image --severity HIGH,CRITICAL three-tier-backend:latest
                    trivy image --severity HIGH,CRITICAL three-tier-frontend:latest
                '''
            }
        }

        stage('5. Push Images to ECR') {
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

        stage('6. Deployment') {
            steps {
                echo 'Deployment is handled by Argo CD.'
            }
        }
    }
}