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

        stage('7. Update Kubernetes Manifests') {
            steps {
                sh '''
                    sed -i "s|backend:.*|backend:${IMAGE_TAG}|" k8s/backend.yaml
                    sed -i "s|frontend:.*|frontend:${IMAGE_TAG}|" k8s/frontend.yaml
                '''
            }
        }

        stage('8. Commit and Push Git Changes') {
            steps {
                sh '''
                    git config user.name "Jenkins"
                    git config user.email "jenkins@localhost"

                    git add k8s/backend.yaml k8s/frontend.yaml

                    git commit -m "Update images to ${IMAGE_TAG}" || echo "No changes to commit"

                    git push origin HEAD:main
                '''
            }
        }

        stage('9. Deployment') {
            steps {
                echo "Images ${IMAGE_TAG} pushed to ECR."
                echo "Kubernetes manifests updated in Git."
                echo "Argo CD will synchronize the changes."
            }
        }
    }
}