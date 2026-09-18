# Three-Tier DevSecOps MERN Application

A beginner-friendly end-to-end DevSecOps project demonstrating how to build, containerize, deploy, secure, and monitor a three-tier MERN application on AWS using Terraform, Jenkins, Docker, Amazon ECR, Amazon EKS, Argo CD, Trivy, Prometheus, and Grafana.

---

## 1. Project Overview

This project implements a three-tier web application consisting of:

* **Frontend** – React.js
* **Backend** – Node.js / Express.js
* **Database** – MongoDB

The application is containerized using Docker and deployed on Kubernetes running on Amazon EKS.

The infrastructure is created using Terraform, while Jenkins handles the CI process and Trivy performs container vulnerability scanning.

For continuous deployment, the project follows a **GitOps approach** using Argo CD. Jenkins updates the Docker image tag in the Kubernetes configuration repository, and Argo CD automatically synchronizes the changes to the EKS cluster.

Prometheus and Grafana are used for monitoring and visualization.

---

# 2. Architecture

```text
                         Developer
                             |
                             | git push
                             v
                    +------------------+
                    |     GitHub       |
                    +------------------+
                             |
                             | Webhook / Poll
                             v
                    +------------------+
                    |     Jenkins      |
                    |                  |
                    |  Build & Test    |
                    |  Trivy Scan      |
                    |  Docker Build    |
                    +------------------+
                             |
                             | Push Image
                             v
                    +------------------+
                    |   Amazon ECR     |
                    |                  |
                    | Frontend Image   |
                    | Backend Image    |
                    +------------------+
                             |
                             | Image Tag
                             | update
                             v
                    +------------------+
                    |     GitHub       |
                    | Kubernetes       |
                    | Manifests        |
                    +------------------+
                             |
                             | GitOps
                             v
                    +------------------+
                    |     Argo CD      |
                    +------------------+
                             |
                             | Sync
                             v
              +--------------------------------+
              |          Amazon EKS             |
              |                                |
              |  +----------+  +-----------+  |
              |  | Frontend |  |  Backend  |  |
              |  |  React   |  | Node.js   |  |
              |  +----------+  +-----------+  |
              |                     |          |
              |                     v          |
              |                +----------+    |
              |                | MongoDB  |    |
              |                +----------+    |
              +--------------------------------+
                             |
                             v
                  +-----------------------+
                  | Prometheus            |
                  | Alertmanager          |
                  | Node Exporter         |
                  | kube-state-metrics    |
                  +-----------------------+
                             |
                             v
                    +------------------+
                    |     Grafana      |
                    |   Dashboards     |
                    +------------------+
```

---

# 3. Technologies Used

| Technology         | Purpose                           |
| ------------------ | --------------------------------- |
| AWS                | Cloud infrastructure              |
| Terraform          | Infrastructure as Code            |
| VPC                | AWS networking                    |
| EKS                | Managed Kubernetes cluster        |
| ECR                | Container image registry          |
| EC2                | Jenkins server                    |
| Jenkins            | CI automation                     |
| Docker             | Application containerization      |
| Trivy              | Container security scanning       |
| GitHub             | Source code and GitOps repository |
| Argo CD            | GitOps continuous deployment      |
| Kubernetes         | Application orchestration         |
| MongoDB            | Application database              |
| Prometheus         | Metrics collection                |
| Grafana            | Monitoring dashboards             |
| Alertmanager       | Alert management                  |
| Node Exporter      | Node-level metrics                |
| kube-state-metrics | Kubernetes object metrics         |

---

# 4. Application Architecture

The application contains three main tiers.

## Frontend

The frontend is a React application.

Responsibilities:

* Provides the user interface
* Communicates with the backend API
* Runs inside a Docker container
* Deployed as a Kubernetes Deployment

## Backend

The backend is a Node.js application.

Responsibilities:

* Provides REST APIs
* Communicates with MongoDB
* Handles application logic
* Runs inside a Docker container
* Deployed as a Kubernetes Deployment

## Database

MongoDB stores application data.

The database is deployed inside the Kubernetes cluster and is exposed only internally using a Kubernetes ClusterIP service.

---

# 5. Repository Structure

The main project directory contains Terraform and application code.

```text
three-tier-devsecops/
│
├── terraform/
│   ├── provider.tf
│   ├── variable.tf
│   ├── terraform.tfvars
│   ├── vpc.tf
│   ├── eks.tf
│   ├── ecr.tf
│   ├── jenkins.tf
│   ├── user_data.sh
│   └── output.tf
│
├── Application-Code/
│   │
│   ├── frontend/
│   │   ├── package.json
│   │   ├── package-lock.json
│   │   ├── Dockerfile
│   │   └── .dockerignore
│   │
│   └── backend/
│       ├── package.json
│       ├── package-lock.json
│       ├── index.js
│       ├── db.js
│       ├── Dockerfile
│       └── .dockerignore
│
└── README.md
```

---

# 6. AWS Infrastructure

Terraform is used to provision the AWS infrastructure.

The infrastructure includes:

* VPC
* Public subnets
* Private subnets
* Internet Gateway
* NAT Gateway
* Route tables
* Security groups
* Jenkins EC2 instance
* IAM roles
* EKS cluster
* EKS managed node group
* ECR repositories

AWS Region used in this project:

```text
ap-south-1
```

EKS cluster:

```text
three-tier-devsecops-eks
```

The EKS cluster currently uses three worker nodes.

---

# 7. Terraform

Terraform is used to create and manage the AWS infrastructure.

Navigate to the Terraform directory:

```bash
cd ~/three-tier-devsecops/terraform
```

Initialize Terraform:

```bash
terraform init
```

Check the configuration:

```bash
terraform validate
```

Format Terraform files:

```bash
terraform fmt
```

Review planned changes:

```bash
terraform plan
```

Apply the infrastructure:

```bash
terraform apply
```

To display Terraform outputs:

```bash
terraform output
```

---

# 8. ECR

Amazon ECR is used to store Docker images.

Two application repositories are used:

```text
three-tier-devsecops/frontend
three-tier-devsecops/backend
```

The Docker images are tagged using the Git commit ID.

Example:

```text
frontend:9b3004f
backend:9b3004f
```

Using Git commit IDs makes it possible to identify exactly which source-code version created an image.

---

# 9. Jenkins

Jenkins runs on an AWS EC2 instance.

Jenkins is responsible for the CI portion of the pipeline.

The pipeline performs tasks such as:

1. Checkout source code
2. Build the application
3. Run tests where applicable
4. Build Docker images
5. Run Trivy security scanning
6. Push images to Amazon ECR
7. Update the Kubernetes image tag in Git

---

# 10. Jenkins Pipeline

The CI/CD flow is:

```text
GitHub
   |
   v
Jenkins
   |
   +--> Checkout
   |
   +--> Build/Test
   |
   +--> Trivy Scan
   |
   +--> Docker Build
   |
   +--> ECR Push
   |
   +--> Update Kubernetes Image Tag
   |
   v
GitHub
```

The latest Jenkins pipeline completed successfully.

---

# 11. Docker

Both frontend and backend applications are containerized.

## Frontend Dockerfile

The frontend Dockerfile creates a Docker image containing the React application.

## Backend Dockerfile

The backend Dockerfile creates a Docker image containing the Node.js application.

Images are built by Jenkins rather than manually building them on the Kubernetes worker nodes.

---

# 12. Trivy Security Scan

Trivy is used as the container vulnerability scanner.

The Jenkins pipeline scans the generated Docker images before they are pushed/deployed.

The pipeline is configured to fail when vulnerabilities with:

```text
HIGH
CRITICAL
```

severity are detected.

This provides a basic DevSecOps security gate.

The flow is:

```text
Docker Build
     |
     v
Trivy Scan
     |
     +---- HIGH/CRITICAL ----> Pipeline Failed
     |
     +---- Acceptable --------> Continue
                                |
                                v
                              ECR
```

---

# 13. Amazon EKS

Amazon EKS is used to run the Kubernetes workloads.

Cluster:

```text
three-tier-devsecops-eks
```

Region:

```text
ap-south-1
```

The cluster contains three worker nodes.

Check the nodes:

```bash
kubectl get nodes
```

Expected status:

```text
Ready
```

---

# 14. Kubernetes Namespaces

The project uses separate namespaces for the application, monitoring, and Argo CD components.

Application namespace:

```text
three-tier-devsecops
```

Monitoring namespace:

```text
monitoring
```

Argo CD namespace:

```text
argocd
```

---

# 15. Application Kubernetes Components

The application namespace contains:

```text
frontend
backend
mongodb
```

Check the application pods:

```bash
kubectl get pods -n three-tier-devsecops
```

Expected result:

```text
frontend    Running
backend     Running
mongodb     Running
```

---

# 16. Kubernetes Services

The application uses three Kubernetes Services.

```text
frontend   LoadBalancer
backend    ClusterIP
mongodb    ClusterIP
```

Check them:

```bash
kubectl get svc -n three-tier-devsecops
```

### Frontend

The frontend is exposed using an AWS LoadBalancer.

Users access the application through the LoadBalancer endpoint.

### Backend

The backend uses a ClusterIP service because it does not need to be directly exposed to the internet.

```text
backend:3500
```

### MongoDB

MongoDB also uses a ClusterIP service and is accessible internally inside the Kubernetes cluster.

```text
mongodb:27017
```

This follows the basic three-tier architecture:

```text
Internet
   |
   v
Frontend
   |
   v
Backend
   |
   v
MongoDB
```

---

# 17. Kubernetes Secrets

Database credentials are not stored directly in the application Deployment manifest.

Kubernetes Secrets are used to provide database credentials to the backend.

This avoids putting the username and password directly into the Deployment configuration.

The backend reads the required values from the Kubernetes Secret.

---

# 18. GitOps with Argo CD

Argo CD is used for continuous deployment.

Instead of Jenkins directly running `kubectl apply`, Jenkins updates the Kubernetes image tag in Git.

Argo CD monitors the Git repository.

When a new Kubernetes configuration is committed:

```text
Git change
    |
    v
Argo CD detects change
    |
    v
Argo CD syncs
    |
    v
EKS deployment updated
```

This is the GitOps model used in this project.

---

# 19. Image Versioning

Docker images are tagged using the application Git commit ID.

For example:

```text
backend:9b3004f
frontend:9b3004f
```

When Jenkins builds a new version:

```text
Git Commit
    |
    v
Docker Image
    |
    v
ECR
    |
    v
Kubernetes manifest updated
    |
    v
Git commit
    |
    v
Argo CD
    |
    v
EKS
```

This provides traceability between source code and the deployed container image.

---

# 20. Argo CD Application Status

The application is registered with Argo CD as:

```text
three-tier-devsecops
```

The current application state is:

```text
SYNC STATUS:   Synced
HEALTH STATUS: Healthy
```

Check the status with:

```bash
kubectl get applications -n argocd
```

---

# 21. Monitoring

The project uses Prometheus and Grafana for Kubernetes monitoring.

The monitoring stack includes:

* Prometheus
* Grafana
* Alertmanager
* Node Exporter
* kube-state-metrics
* Prometheus Operator

---

# 22. Prometheus

Prometheus collects metrics from:

* Kubernetes components
* Worker nodes
* Kubernetes objects
* Applications and exporters where configured

Check Prometheus:

```bash
kubectl get pods -n monitoring
```

Prometheus is kept internal to the cluster.

---

# 23. Grafana

Grafana is used to visualize the metrics collected by Prometheus.

Grafana is exposed through a Kubernetes LoadBalancer.

Access Grafana using the external LoadBalancer endpoint.

The Grafana credentials are stored in a Kubernetes Secret.

Retrieve the username:

```bash
kubectl get secret monitoring-grafana -n monitoring \
  -o jsonpath="{.data.admin-user}" | base64 --decode
echo
```

Retrieve the password:

```bash
kubectl get secret monitoring-grafana -n monitoring \
  -o jsonpath="{.data.admin-password}" | base64 --decode
echo
```

After logging into Grafana, Kubernetes monitoring dashboards can be used to view cluster and node metrics.

---

# 24. Alertmanager

Alertmanager is part of the monitoring stack.

It handles alerts generated by Prometheus.

Check Alertmanager:

```bash
kubectl get pods -n monitoring
```

The Alertmanager pod should be in the:

```text
Running
```

state.

---

# 25. Node Exporter

Node Exporter collects metrics from Kubernetes worker nodes.

Because the cluster currently has three worker nodes, three Node Exporter pods are running.

Check:

```bash
kubectl get pods -n monitoring | grep node-exporter
```

---

# 26. kube-state-metrics

kube-state-metrics provides metrics about Kubernetes objects such as:

* Pods
* Deployments
* Services
* Nodes
* ReplicaSets

Check:

```bash
kubectl get pods -n monitoring
```

---

# 27. Useful Kubernetes Commands

### View all pods

```bash
kubectl get pods -A
```

### View application pods

```bash
kubectl get pods -n three-tier-devsecops
```

### View services

```bash
kubectl get svc -n three-tier-devsecops
```

### View nodes

```bash
kubectl get nodes
```

### View Argo CD application

```bash
kubectl get applications -n argocd
```

### View monitoring pods

```bash
kubectl get pods -n monitoring
```

### View backend logs

```bash
kubectl logs -n three-tier-devsecops deployment/backend
```

### View frontend logs

```bash
kubectl logs -n three-tier-devsecops deployment/frontend
```

### View MongoDB logs

```bash
kubectl logs -n three-tier-devsecops deployment/mongodb
```

---

# 28. End-to-End DevSecOps Workflow

The complete workflow is:

### Step 1 – Developer changes code

Developer modifies the application source code.

```text
Application-Code/
```

### Step 2 – Push to GitHub

```bash
git add .
git commit -m "Update application"
git push
```

### Step 3 – Jenkins starts

Jenkins retrieves the latest source code.

### Step 4 – Build and test

Jenkins builds the application.

### Step 5 – Docker image creation

Jenkins creates frontend and backend Docker images.

### Step 6 – Security scan

Trivy scans the images.

HIGH and CRITICAL vulnerabilities cause the pipeline to fail.

### Step 7 – Push to ECR

Successful images are pushed to Amazon ECR.

### Step 8 – Update image tag

Jenkins updates the Kubernetes manifests with the new Git commit/image tag.

### Step 9 – GitOps commit

The updated Kubernetes configuration is pushed to GitHub.

### Step 10 – Argo CD detects the change

Argo CD notices the Git repository change.

### Step 11 – Argo CD synchronizes

Argo CD updates the Kubernetes workloads.

### Step 12 – Application runs on EKS

The new application version is deployed.

### Step 13 – Monitoring

Prometheus collects metrics and Grafana displays them.

---

# 29. Security Practices Used

This project demonstrates several basic security practices.

### Container scanning

Trivy scans Docker images for vulnerabilities.

### Vulnerability gate

HIGH and CRITICAL vulnerabilities can stop the Jenkins pipeline.

### IAM roles

Jenkins uses AWS IAM permissions rather than storing AWS access keys directly on the server.

### Kubernetes Secrets

Database credentials are stored using Kubernetes Secrets rather than being directly embedded in Deployment manifests.

### Private application services

Backend and MongoDB use ClusterIP services and are not directly exposed through public LoadBalancers.

### Git-based deployment

Argo CD provides controlled GitOps-based deployment.

---

# 30. Why GitOps?

Traditional approach:

```text
Jenkins
   |
   +---- kubectl apply
   |
   v
Kubernetes
```

GitOps approach used here:

```text
Jenkins
   |
   v
Update Git
   |
   v
Argo CD
   |
   v
Kubernetes
```

The Git repository becomes the desired-state source for the application deployment.

This makes deployment changes easier to track and audit.

---

# 31. Why Terraform?

Without Terraform, AWS resources would need to be created manually.

Terraform allows the infrastructure to be defined as code.

Advantages demonstrated in this project:

* Repeatable infrastructure
* Version-controlled infrastructure
* Easier changes
* Infrastructure planning
* Reduced manual configuration

Useful commands:

```bash
terraform init
terraform validate
terraform fmt
terraform plan
terraform apply
terraform output
```

---

# 32. Troubleshooting Commands

### Check all workloads

```bash
kubectl get pods -A
```

### Check services

```bash
kubectl get svc -A
```

### Check nodes

```bash
kubectl get nodes
```

### Check Argo CD

```bash
kubectl get pods -n argocd
kubectl get applications -n argocd
```

### Check monitoring

```bash
kubectl get pods -n monitoring
```

### Check application

```bash
kubectl get pods -n three-tier-devsecops
kubectl get svc -n three-tier-devsecops
```

### Describe a pod

```bash
kubectl describe pod <pod-name> -n <namespace>
```

### View pod logs

```bash
kubectl logs <pod-name> -n <namespace>
```

---

# 33. Current Project Health

At the time of project completion, the following components were verified:

```text
Terraform              ✅
AWS VPC                ✅
EKS                    ✅
ECR                    ✅
Jenkins                ✅
Docker                 ✅
Trivy                  ✅
GitOps                 ✅
Argo CD                 ✅
Frontend               ✅
Backend                ✅
MongoDB                ✅
Prometheus             ✅
Grafana                ✅
Alertmanager           ✅
Node Exporter          ✅
kube-state-metrics     ✅
```

Argo CD:

```text
Sync Status:   Synced
Health Status: Healthy
```

Jenkins:

```text
Latest Pipeline: SUCCESS
```

---

# 34. Demo Flow

For a mentor demonstration, the project can be explained in the following order.

## 1. Explain the architecture

Start with:

```text
Developer
   ↓
GitHub
   ↓
Jenkins
   ↓
Trivy
   ↓
ECR
   ↓
GitOps
   ↓
Argo CD
   ↓
EKS
   ↓
Application
   ↓
Prometheus + Grafana
```

## 2. Show Terraform

Explain that Terraform creates the AWS infrastructure.

Show:

```text
terraform/
```

and the main Terraform files.

## 3. Show Jenkins

Open Jenkins and show the successful pipeline.

Explain the stages:

```text
Checkout
Build/Test
Trivy Scan
Docker Build
ECR Push
GitOps Image Update
```

## 4. Show ECR

Show the frontend and backend repositories and their image tags.

Explain that the image tag is based on the Git commit.

## 5. Show Kubernetes

Run:

```bash
kubectl get nodes
```

Then:

```bash
kubectl get pods -n three-tier-devsecops
```

Then:

```bash
kubectl get svc -n three-tier-devsecops
```

Explain the three-tier application.

## 6. Show Argo CD

Run:

```bash
kubectl get applications -n argocd
```

Show:

```text
Synced
Healthy
```

Explain that Argo CD deploys the desired state from Git.

## 7. Show Grafana

Open Grafana and show Kubernetes monitoring dashboards.

Explain that Prometheus collects metrics and Grafana visualizes them.

---

# 35. Important Project Concepts to Explain

During the demonstration, the following concepts can be explained:

### CI

Continuous Integration is demonstrated using Jenkins.

### DevSecOps

Security is integrated into the CI pipeline using Trivy.

### Containerization

Docker packages the frontend and backend applications.

### Container Registry

Amazon ECR stores the Docker images.

### Kubernetes

Amazon EKS runs and manages the application containers.

### GitOps

Argo CD continuously synchronizes Kubernetes with the desired configuration stored in Git.

### Infrastructure as Code

Terraform creates AWS infrastructure using code.

### Monitoring

Prometheus collects metrics and Grafana provides visualization.

---

# 36. Project Outcome

This project demonstrates an end-to-end DevSecOps workflow for a containerized three-tier MERN application.

The project covers:

```text
Infrastructure as Code
        +
Containerization
        +
Continuous Integration
        +
Security Scanning
        +
Container Registry
        +
Kubernetes
        +
GitOps
        +
Continuous Deployment
        +
Monitoring
```

The final application runs on Amazon EKS, is deployed using Argo CD, images are built and scanned by Jenkins/Trivy, and the Kubernetes environment is monitored using Prometheus and Grafana.

---

# 37. Future Improvements

The current project intentionally keeps the architecture beginner-friendly.

Possible future improvements include:

* HTTPS using AWS Load Balancer / TLS
* Ingress controller
* External secrets management
* AWS Secrets Manager
* Persistent storage for MongoDB
* Automated backup
* More comprehensive automated tests
* Centralized logging
* Kubernetes resource limits and requests
* Horizontal Pod Autoscaling
* Separate staging and production environments
* Automated rollback strategies
* More advanced GitOps repository structure

These improvements are outside the scope of the current implementation.

---

# 38. Cleanup

When the project is no longer required, AWS resources should be removed to avoid unnecessary charges.

From the Terraform directory:

```bash
cd ~/three-tier-devsecops/terraform
```

Review what Terraform manages:

```bash
terraform plan
```

If the complete project is no longer required:

```bash
terraform destroy
```

Review the resources carefully before confirming the destroy operation.

> Do not run `terraform destroy` while the environment is required for a mentor demonstration.

---

# 39. Conclusion

This project provides a practical beginner-friendly implementation of a complete DevSecOps lifecycle.

The final workflow is:

```text
Code
  ↓
GitHub
  ↓
Jenkins
  ↓
Build & Test
  ↓
Trivy Security Scan
  ↓
Docker Image
  ↓
Amazon ECR
  ↓
GitOps Image Update
  ↓
Argo CD
  ↓
Amazon EKS
  ↓
Frontend + Backend + MongoDB
  ↓
Prometheus
  ↓
Grafana
```

The project demonstrates how development, infrastructure, security, deployment, GitOps, Kubernetes, and monitoring can be combined into a single DevSecOps workflow.
