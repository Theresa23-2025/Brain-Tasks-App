# Brain-Tasks-App Deployment on AWS EKS

## Full Production Deployment Documentation

### Original GitHub Repository

```text
https://github.com/Vennilavanguvi/Brain-Tasks-App.git
```

### Deployment Repository

```text
https://github.com/Vennilavanguvi/Brain-Tasks-App.git
```

---

# Project Information

| Item                        | Value               |
| --------------------------- | ------------------- |
| **Project Name**            | **Brain-Tasks-App** |
| **Application Type**        | React + Vite        |
| **Container Platform**      | Docker              |
| **Container Registry**      | Amazon ECR          |
| **Kubernetes Platform**     | Amazon EKS          |
| **AWS Region**              | ap-south-1 (Mumbai) |
| **Local Port**              | 3000                |
| **Container Port**          | 80                  |
| **Kubernetes Service Type** | LoadBalancer        |

---

# Application Overview

This project demonstrates the **end-to-end production deployment** of the **Brain-Tasks-App** using:

* **React + Vite** for frontend development
* **Docker** for containerization
* **Amazon Elastic Container Registry (ECR)** for storing Docker images
* **Amazon Elastic Kubernetes Service (EKS)** for container orchestration
* **Kubernetes Deployment and Service YAML files** for application deployment
* **AWS CodeBuild** for CI/CD build automation
* **AWS CodePipeline** for automated deployment workflow
* **Amazon CloudWatch Logs** for monitoring and logging

---

# Project Folder Structure

```text
Brain-Tasks-App/
│
├── dist/
│   ├── assets/
│   ├── index.html
│   └── vite.svg
│
├── Dockerfile
├── .dockerignore
├── docker-compose.yml
├── deployment.yaml
├── service.yaml
├── buildspec.yml
├── README.md
└── package.json
```

---

# Prerequisites

Install the following software before starting the deployment.

## Required Tools

| Tool           | Purpose                   |
| -------------- | ------------------------- |
| Node.js        | Build React application   |
| npm            | Package management        |
| Docker Desktop | Build and run containers  |
| AWS CLI        | Connect to AWS services   |
| kubectl        | Manage Kubernetes cluster |
| Git            | Version control           |

---

# Step 1 – Clone the Repository

```bash
git clone https://github.com/Vennilavanguvi/Brain-Tasks-App.git
```

Move into the project directory:

```bash
cd Brain-Tasks-App
```

---

# Step 2 – Install Dependencies

```bash
npm install
```

---

# Step 3 – Build the React Application

```bash
npm run build
```

After successful execution, the **dist** folder is created.

### Build Output Structure

```text
dist/
├── assets/
│   ├── index-BHGiHu50.js
│   └── index-DPTLVrPB.css
├── index.html
└── vite.svg
```

---

# Step 4 – Create Dockerfile

Create a file named **Dockerfile** in the project root.

## Dockerfile

```dockerfile
FROM nginx:alpine

WORKDIR /usr/share/nginx/html

COPY dist .

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

---

# Step 5 – Create .dockerignore

Create **.dockerignore**.

```text
node_modules
.git
Dockerfile
README.md
```

---

# Step 6 – Build Docker Image

Run the following command from the project root.

```bash
docker build -t brain-tasks-app .
```

Verify the image:

```bash
docker images
```

Expected output:

```text
REPOSITORY         TAG       IMAGE ID
brain-tasks-app    latest    xxxxxxxxxxxx
```

---

# Step 7 – Run Docker Container Locally

```bash
docker run -d -p 3000:80 --name brainapp brain-tasks-app
```

Check running containers:

```bash
docker ps
```

Open in browser:

```text
http://localhost:3000
```

The Brain-Tasks-App should load successfully.

---

# Step 8 – Create Amazon ECR Repository

Open **AWS Console**.

Navigate to:

```text
Amazon ECR → Create Repository
```

### Repository Configuration

| Setting         | Value           |
| --------------- | --------------- |
| Repository Name | brain-tasks-app |
| Visibility      | Private         |

---

# Step 9 – Configure AWS CLI

Configure AWS credentials.

```bash
aws configure
```

Enter:

```text
AWS Access Key ID
AWS Secret Access Key
Default region name: ap-south-1
Default output format: json
```

Verify identity:

```bash
aws sts get-caller-identity
```

---

# Step 10 – Authenticate Docker to ECR

```bash
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 037063405138.dkr.ecr.ap-south-1.amazonaws.com
```

---

# Step 11 – Tag Docker Image

```bash
docker tag brain-tasks-app:latest 037063405138.dkr.ecr.ap-south-1.amazonaws.com/brain-tasks-app:latest
```

---

# Step 12 – Push Docker Image to ECR

```bash
docker push 037063405138.dkr.ecr.ap-south-1.amazonaws.com/brain-tasks-app:latest
```

Verify pushed images:

```bash
aws ecr list-images --repository-name brain-tasks-app --region ap-south-1
```

---

# Step 13 – Create Amazon EKS Cluster

Open **AWS Console → Amazon EKS**.

Create a cluster with the following configuration.

| Setting            | Value         |
| ------------------ | ------------- |
| Cluster Name       | brain-cluster |
| Region             | ap-south-1    |
| Kubernetes Version | Latest        |
| Node Group         | Managed       |
| Instance Type      | t3.medium     |

Wait until the cluster status becomes:

```text
ACTIVE
```

---

# Step 14 – Configure kubectl for EKS

Run:

```bash
aws eks update-kubeconfig --region ap-south-1 --name brain-cluster
```

Verify connection:

```bash
kubectl get nodes
```

Expected:

```text
NAME              STATUS   ROLES    AGE
ip-xxx-xxx        Ready    <none>   xxm
```

---

# Step 15 – Create Kubernetes Deployment

Create **deployment.yaml**.

## deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment

metadata:
  name: brain-task

spec:
  replicas: 2

  selector:
    matchLabels:
      app: brain-task

  template:
    metadata:
      labels:
        app: brain-task

    spec:
      containers:
      - name: brain-task

        image: 037063405138.dkr.ecr.ap-south-1.amazonaws.com/brain-tasks-app:latest

        ports:
        - containerPort: 80
```

Apply the deployment:

```bash
kubectl apply -f deployment.yaml
```

Check deployment:

```bash
kubectl get deployment
```

---

# Step 16 – Create Kubernetes Service

Create **service.yaml**.

## service.yaml

```yaml
apiVersion: v1
kind: Service

metadata:
  name: brain-task-service

spec:
  type: LoadBalancer

  selector:
    app: brain-task

  ports:
  - port: 80
    targetPort: 80
```

Apply the service:

```bash
kubectl apply -f service.yaml
```

---

# Step 17 – Verify Kubernetes Resources

## Check Pods

```bash
kubectl get pods
```

## Check Services

```bash
kubectl get svc
```

Expected:

```text
NAME                 TYPE           CLUSTER-IP       EXTERNAL-IP
brain-task-service   LoadBalancer   10.100.x.x       a6541b307a7f14a32b3390c165e7de3d-488304798.ap-south-1.elb.amazonaws.com
```

---

# Application LoadBalancer URL

## Public Application URL

```text
http://a6541b307a7f14a32b3390c165e7de3d-488304798.ap-south-1.elb.amazonaws.com
```

### Status

**Successfully Running**

This confirms that:

* EKS cluster is functioning correctly
* Pods are running
* Kubernetes Service is exposing the application
* AWS Elastic Load Balancer is routing traffic properly

---

# Step 18 – Create buildspec.yml

Create **buildspec.yml** in the project root.

## buildspec.yml

```yaml
version: 0.2

phases:
  pre_build:
    commands:
      - echo Logging in to Amazon ECR...
      - aws --version
      - aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 037063405138.dkr.ecr.ap-south-1.amazonaws.com

  build:
    commands:
      - echo Build started on `date`
      - docker build -t brain-tasks-app .
      - docker tag brain-tasks-app:latest 037063405138.dkr.ecr.ap-south-1.amazonaws.com/brain-tasks-app:latest

  post_build:
    commands:
      - echo Build completed on `date`
      - docker push 037063405138.dkr.ecr.ap-south-1.amazonaws.com/brain-tasks-app:latest

artifacts:
  files:
    - '**/*'
```

---

# Step 19 – AWS CodeBuild Configuration

Open **AWS Console → CodeBuild**.

## Project Settings

| Setting         | Value             |
| --------------- | ----------------- |
| Project Name    | BrainTasks-Build  |
| Source Provider | GitHub            |
| Repository      | Brain-Tasks-App   |
| Environment     | Amazon Linux 2023 |
| Runtime         | Standard          |
| Privileged Mode | Enabled           |
| Buildspec       | buildspec.yml     |

---

# CodeBuild Quota Issue

The AWS account currently has the following quota restriction.

## Current Quota

```text
Concurrently running builds for Linux/Small environment = 0
```

Because of this, builds cannot start.

### Error Message

```text
Build failed to start.
Cannot have more than 0 builds in queue for the account.
```

---

# AWS Support Quota Request

A quota increase request has already been submitted.

| Item            | Value                                                   |
| --------------- | ------------------------------------------------------- |
| Service         | AWS CodeBuild                                           |
| Quota           | Concurrently running builds for Linux/Small environment |
| Requested Value | 1                                                       |
| Region          | ap-south-1                                              |
| Status          | Case Opened                                             |
| Support Case ID | 178530586400301                                         |

This is the current pending step for completing CI/CD automation.

---

# Step 20 – Planned AWS CodePipeline

## Pipeline Flow

```text
GitHub Repository
        ↓
AWS CodeBuild
        ↓
Amazon ECR
        ↓
Amazon EKS
```

### Planned Pipeline Name

```text
BrainTasks-Pipeline
```

---

# Step 21 – CloudWatch Monitoring

Amazon CloudWatch is configured for monitoring.

## Expected Log Groups

```text
/aws/codebuild/BrainTasks-Build
/aws/codepipeline/BrainTasks-Pipeline
```

These logs will become available after successful CodeBuild execution.

---

# Optional – Docker Compose

## docker-compose.yml

```yaml
version: '3'

services:
  brain-tasks-app:
    build: .

    ports:
      - "3000:80"

    container_name: brain-tasks-app
```

Start with:

```bash
docker-compose up -d
```

Stop with:

```bash
docker-compose down
```

---

# Git Commands Used

## Initialize Repository

```bash
git init
```

## Add Files

```bash
git add .
```

## Commit

```bash
git commit -m "Initial deployment commit"
```

## Push to GitHub

```bash
git branch -M main
git push -u origin main
```

---

# Validation Commands

## Docker Validation

```bash
docker ps
docker images
docker logs brainapp
```

---

## Kubernetes Validation

```bash
kubectl get nodes
kubectl get deployments
kubectl get pods
kubectl get svc
kubectl describe svc brain-task-service
```

---

# Deployment Status Summary

## Completed Tasks

| Task                                  | Status    |
| ------------------------------------- | --------- |
| Clone repository                      | Completed |
| Install dependencies                  | Completed |
| Build React application               | Completed |
| Generate dist folder                  | Completed |
| Create Dockerfile                     | Completed |
| Create .dockerignore                  | Completed |
| Build Docker image                    | Completed |
| Run Docker container locally          | Completed |
| Create Amazon ECR repository          | Completed |
| Authenticate Docker with ECR          | Completed |
| Tag Docker image                      | Completed |
| Push image to ECR                     | Completed |
| Create Amazon EKS cluster             | Completed |
| Configure kubectl                     | Completed |
| Create deployment.yaml                | Completed |
| Create service.yaml                   | Completed |
| Deploy application to EKS             | Completed |
| Expose application using LoadBalancer | Completed |
| Verify public application access      | Completed |
| Create buildspec.yml                  | Completed |
| Create CodeBuild project              | Completed |
| Submit CodeBuild quota request        | Completed |

---

## Pending Tasks

| Task                                   | Status                     |
| -------------------------------------- | -------------------------- |
| CodeBuild execution                    | Pending AWS quota approval |
| CodePipeline creation                  | Pending                    |
| Automatic EKS deployment from pipeline | Pending                    |
| CloudWatch log verification            | Pending                    |
| Final CI/CD screenshots                | Pending                    |

---

# Screenshots to Attach

Include these screenshots in the final submission.

## Local Environment

* Project folder structure
* Docker build success
* Docker images
* Docker container running

## AWS ECR

* ECR repository created
* Image available in ECR

## AWS EKS

* EKS cluster status = Active
* Node group running
* kubectl get nodes
* kubectl get pods
* kubectl get svc

## Application

* Browser showing the LoadBalancer URL
* Brain-Tasks-App homepage loaded successfully

## AWS CodeBuild

* Build project configuration
* Quota request history
* Support case status

---

# Troubleshooting

## Rebuild React Application

```bash
npm run build
```

---

## Rebuild Docker Image

```bash
docker build --no-cache -t brain-tasks-app .
```

---

## Restart Kubernetes Deployment

```bash
kubectl rollout restart deployment brain-task
```

---

## View Pod Logs

```bash
kubectl logs -l app=brain-task
```

---

## Update kubeconfig Again

```bash
aws eks update-kubeconfig --region ap-south-1 --name brain-cluster
```

---

# Final Result

The **Brain-Tasks-App** has been successfully deployed to **Amazon EKS** with the following completed achievements.

## Successfully Implemented

* React + Vite application build
* Docker containerization
* Amazon ECR image storage
* Amazon EKS Kubernetes cluster
* Kubernetes Deployment configuration
* Kubernetes LoadBalancer Service
* Public application access through AWS ELB
* CI/CD configuration files (`buildspec.yml`, `deployment.yaml`, `service.yaml`)
* GitHub version control integration

## Live Application

```text
http://a6541b307a7f14a32b3390c165e7de3d-488304798.ap-south-1.elb.amazonaws.com
```

The application is **publicly accessible and running successfully on AWS EKS**.

The only remaining work is the **AWS CodeBuild quota approval**, after which **CodePipeline and automated CI/CD deployment** can be completed.


