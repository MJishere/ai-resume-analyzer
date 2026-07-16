# AI Resume Analyzer | End-to-End DevOps on AWS

A production-ready AI Resume Analyzer showcasing modern DevOps practices through Infrastructure as Code, CI/CD automation, Kubernetes orchestration, monitoring, and security on AWS.

This project demonstrates:

- Infrastructure provisioning on AWS using modular Terraform with remote state management (Amazon S3 & DynamoDB)
- Automated Jenkins server bootstrap on Amazon EC2 using Terraform and EC2 User Data
- Four dedicated Jenkins pipelines for infrastructure provisioning, application deployment, Helm-based cluster setup, and infrastructure destruction
- Automated CI/CD pipeline with Ruff linting, Pytest, Trivy security scanning, Docker image build, Amazon ECR integration, and deployment to Amazon EKS
- Kubernetes application deployment with Deployments, Services, ConfigMaps, Secrets, and AWS Application Load Balancer Ingress
- Helm and shell script automation for installing the AWS Load Balancer Controller, Metrics Server, and kube-prometheus-stack
- Cluster monitoring and observability using Prometheus and Grafana
- Secure deployment using IAM Roles, private networking, Kubernetes Secrets, and container vulnerability scanning
- AI-powered resume analysis using FastAPI, Streamlit, PDF processing, and OpenAI GPT-5.4 Nano
# Architecture Diagram
## Architecture Diagram - Jenkins Bootstrap
![Architecture Diagram - Jenkins Bootstrap](https://raw.githubusercontent.com/MJishere/ai-resume-analyzer/main/docs/images/Architecture/Jenkins-bootstrap.drawio.png)

## Architecture Diagram - Infrastructure & CI/CD
![Architecture Diagram - Infrastructure & CI/CD](https://raw.githubusercontent.com/MJishere/ai-resume-analyzer/main/docs/images/Architecture/CI-CD-Infrastructure.drawio.png)

## Architecture Diagram - Runtime Architecture
![Architecture Diagram - Runtime Architecture](https://raw.githubusercontent.com/MJishere/ai-resume-analyzer/main/docs/images/Architecture/Runtime-Architecture.drawio.png)

# Screenshots

## 🖥️ Application

### Home Page
![Application Home Page](https://raw.githubusercontent.com/MJishere/ai-resume-analyzer/main/docs/screenshots/Application-HomePage.png)

### Resume Analysis Results
![Resume Analysis Results](https://raw.githubusercontent.com/MJishere/ai-resume-analyzer/main/docs/screenshots/Resume-Analysis.png)

### Application Load Balancers
![Application Load Balancers](https://raw.githubusercontent.com/MJishere/ai-resume-analyzer/main/docs/screenshots/Application-LoadBalancers.png)

---

## 🚀 CI/CD Pipelines

### Terraform AWS Infrastructure Provisioning Pipeline
![Terraform AWS Infrastructure Provisioning Pipeline](https://raw.githubusercontent.com/MJishere/ai-resume-analyzer/main/docs/screenshots/Terraform-AWS-Infra-Provision-Pipeline.png)

### Application CI/CD Pipeline
![Application CI/CD Pipeline](https://raw.githubusercontent.com/MJishere/ai-resume-analyzer/main/docs/screenshots/CI-CD-Pipeline.png)

### Helm Cluster Setup Pipeline
![Helm Cluster Setup Pipeline](https://raw.githubusercontent.com/MJishere/ai-resume-analyzer/main/docs/screenshots/Helm-Cluster-Setup-Pipeline.png)

---

## ☸️ Kubernetes

### Amazon EKS Cluster
![Amazon EKS Cluster](https://raw.githubusercontent.com/MJishere/ai-resume-analyzer/main/docs/screenshots/EKS-Cluster-Console.png)

### Running Kubernetes Resources
![Running Kubernetes Resources](https://raw.githubusercontent.com/MJishere/ai-resume-analyzer/main/docs/screenshots/Kubernetes-Resources.png)

---

## 📊 Monitoring

### Grafana Dashboard
![Grafana Dashboard](https://raw.githubusercontent.com/MJishere/ai-resume-analyzer/main/docs/screenshots/Grafana-Dashboards.png)

### Prometheus Dashboard
![Prometheus Dashboard](https://raw.githubusercontent.com/MJishere/ai-resume-analyzer/main/docs/screenshots/Prometheus-Dashboard.png)

---

## ⚙️ Jenkins

### Jenkins Server
![Jenkins Server](https://raw.githubusercontent.com/MJishere/ai-resume-analyzer/main/docs/screenshots/Jenkins-Server.png)

# Architecture Summary

The project is divided into four major phases, each managed independently to simulate a production-grade DevOps workflow.

## Phase 1 - Jenkins Bootstrap (Local Execution)

The `jenkins-bootstrap/` Terraform configuration is executed locally to provision and configure the Jenkins server.

This phase provisions:

- Amazon EC2 instance for Jenkins
- Elastic IP
- IAM Role and Instance Profile
- Security Group
- Amazon S3 bucket for Terraform remote state
- DynamoDB table for Terraform state locking

The EC2 instance is automatically configured using **User Data**, which installs and configures:

- Docker
- AWS CLI
- Terraform
- kubectl
- Git
- Jenkins (running as a Docker container)

---

## Phase 2 - Infrastructure Provisioning

The infrastructure pipeline (`Jenkinsfile.infra`) provisions the AWS resources required for the application using modular Terraform.

Resources created include:

- Amazon VPC
- Public & Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- IAM Roles & Policies
- Amazon ECR Repositories
- Amazon EKS Cluster
- Managed Node Group

---

## Phase 3 - Application Deployment

The application pipeline (`Jenkinsfile`) performs a complete CI/CD workflow.

Pipeline stages include:

- Source Code Checkout
- Dependency Installation
- Ruff Linting
- Pytest Execution
- Docker Image Build
- Trivy Image Scan
- Push Images to Amazon ECR
- Create Kubernetes Secret for OpenAI API Key
- Deploy Frontend & Backend to Amazon EKS
- Update Kubernetes Services and Ingress

The application is deployed with:

- FastAPI Backend (2 Replicas)
- Streamlit Frontend (2 Replicas)
- Kubernetes Deployments
- Services
- ConfigMaps
- Secrets
- AWS Application Load Balancer Ingress

## Phase 4 - Kubernetes Cluster Setup

The Helm pipeline (`Jenkinsfile.helm`) prepares the Kubernetes cluster by installing the required add-ons.

Using Helm and shell scripts, it installs:

- AWS Load Balancer Controller
- Metrics Server
- kube-prometheus-stack
    - Prometheus
    - Grafana

This phase enables:

- External application access through AWS Application Load Balancer
- Cluster metrics collection
- Monitoring and observability



---

## Infrastructure Cleanup

The infrastructure destroy pipeline (`Jenkinsfile.infra-destroy`) cleanly removes all AWS resources provisioned by Terraform when they are no longer required.
# Deployment

## Prerequisites

Before deploying the project, ensure the following are available:

- AWS Account
- OpenAI API Key
- Terraform installed locally
- Git
- Docker (for local development)

---

## Deployment Workflow

### Step 1 - Bootstrap Jenkins

Run the Terraform configuration inside `jenkins-bootstrap/` locally.

This provisions:

- Jenkins EC2 Server
- S3 Remote Backend ---------------> Utilized by Step 2
- DynamoDB State Locking ---------> Utilized by Step 2
- Jenkins running inside Docker

---

### Step 2 - Provision AWS Infrastructure

Create a Jenkins Pipeline using:

```
jenkins/Jenkinsfile.infra
```

This provisions:

- VPC
- IAM
- Amazon ECR
- Amazon EKS
- Managed Node Group

---

### Step 3 - Configure the Kubernetes Cluster

Run:

```
jenkins/Jenkinsfile.helm
```

This installs:

- AWS Load Balancer Controller
- Metrics Server
- kube-prometheus-stack
    - Prometheus
    - Grafana

---

### Step 4 - Deploy the Application

Run:

```
jenkins/Jenkinsfile
```

The pipeline automatically:

- Checks out the source code
- Runs Ruff linting
- Executes Pytest
- Builds Docker images
- Performs Trivy image scan
- Pushes images to Amazon ECR
- Creates the Kubernetes Secret for the OpenAI API Key
- Deploys the application to Amazon EKS

---

### Step 5 - Destroy Infrastructure

To clean up AWS resources, execute:

```
Jenkinsfiles/Jenkinsfile.infra-destroy
```
# Jenkins Credentials
The following credentials must be configured in Jenkins before executing the pipelines.

| Credential ID | Type | Purpose |
|--------------|------|---------|
| `openai_api_key` | Secret Text | OpenAI API key injected into Kubernetes as a Secret during deployment |

> **Note**
>
> The OpenAI API key is **not stored in the repository**. During the application deployment pipeline, Jenkins securely creates a Kubernetes Secret from the configured Jenkins credential.

# Monitoring

Cluster monitoring is implemented using the **kube-prometheus-stack** Helm chart.

The monitoring stack includes:

- Prometheus
- Grafana
- Node Exporter
- kube-state-metrics

The stack provides visibility into:

- Kubernetes Nodes
- Pods
- Deployments
- CPU Utilization
- Memory Utilization
- Cluster Health

# Application Features

The AI Resume Analyzer evaluates uploaded resumes against a target role or job description using **OpenAI GPT-5.4 Nano**.

The generated analysis includes:

- ATS Score
- Role Match Score
- Professional Summary
- Resume Strengths
- Missing Skills
- Improvement Suggestions

# Future Improvements

- Horizontal Pod Autoscaler (HPA)
- HTTPS using AWS Certificate Manager
- GitOps with Argo CD
- SonarQube integration
- Centralized logging using Loki or ELK
- Automated backup and disaster recovery
## 🔗 Links

[![linkedin](https://img.shields.io/badge/github-808080?style=for-the-badge&logo=github&logoColor=grey)](https://github.com/MJishere)

[![github](https://img.shields.io/badge/linkedin-0A66C2?style=for-the-badge&logo=github&logoColor=white)](https://www.linkedin.com/in/manoj-m-mj/)


# Author

**Manoj M**

AWS Certified | Teraform Certified | Cloud & DevOps Engineer

- GitHub: https://github.com/MJishere
- LinkedIn: https://www.linkedin.com/in/manoj-m-mj/