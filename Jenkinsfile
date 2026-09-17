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

        stage('2. Get Git SHA') {
            steps {
                script {
                    env.IMAGE_TAG = sh(
                        script: 'git rev-parse --short HEAD',
                        returnStdout: true
                    ).trim()

                    echo "Docker image tag: ${env.IMAGE_TAG}"
                }
            }
        }

        stage('3. Test') {
            steps {
                echo 'Running application tests...'
            }
        }

        stage('4. Build Docker Images') {
            steps {
                sh '''
                    docker build -t three-tier-backend:${IMAGE_TAG} ./Application-Code/backend
                    docker build -t three-tier-frontend:${IMAGE_TAG} ./Application-Code/frontend
                '''
            }
        }

        stage('5. Trivy Security Scan') {
            steps {
                sh '''
                    trivy image --severity HIGH,CRITICAL three-tier-backend:${IMAGE_TAG}
                    trivy image --severity HIGH,CRITICAL three-tier-frontend:${IMAGE_TAG}
                '''
            }
        }

        stage('6. Push Images to ECR') {
            steps {
                sh '''
                    aws ecr get-login-password --region "$AWS_REGION" | \
                    docker login --username AWS --password-stdin "$ECR_REGISTRY"

                    docker tag three-tier-backend:${IMAGE_TAG} "$BACKEND_IMAGE:${IMAGE_TAG}"
                    docker tag three-tier-frontend:${IMAGE_TAG} "$FRONTEND_IMAGE:${IMAGE_TAG}"

                    docker push "$BACKEND_IMAGE:${IMAGE_TAG}"
                    docker push "$FRONTEND_IMAGE:${IMAGE_TAG}"
                '''
            }
        }

        stage('7. Deployment') {
            steps {
                echo "Image ${IMAGE_TAG} pushed to ECR."
                echo 'Deployment is handled by Argo CD.'
            }
        }
    }
}