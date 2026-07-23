# Brain Tasks App - DevOps Deployment using AWS

## Project Overview

This project demonstrates the complete deployment of a React application using modern DevOps practices on AWS.

The application is containerized using Docker, stored in Amazon ECR, deployed on Amazon EKS using Kubernetes, and automated using AWS CodeBuild and CodePipeline.

---

# Architecture

```

GitHub Repository
│
▼
AWS CodePipeline
│
▼
AWS CodeBuild
│
▼
Docker Build
│
▼
Amazon ECR
│
▼
Amazon EKS Cluster
│
▼
Kubernetes Deployment
│
▼
Kubernetes Service (LoadBalancer)
│
▼
React Application

```

---

# Technologies Used

- React.js
- Docker
- Amazon Elastic Container Registry (ECR)
- Amazon Elastic Kubernetes Service (EKS)
- Kubernetes
- AWS CodeBuild
- AWS CodePipeline
- AWS CloudWatch
- GitHub

---

# Project Structure

```

Brain-Tasks-App/
│
├── public/
├── src/
├── Dockerfile
├── deployment.yaml
├── service.yaml
├── buildspec.yml
├── package.json
├── package-lock.json
├── README.md

```

---

# Step 1 Clone Repository

Clone the repository from GitHub.

```bash
git clone https://github.com/Theresa23-2025/Brain-Tasks-App.git

cd Brain-Tasks-App
```

---

# Step 2 Install Dependencies

```bash
npm install
```

---

# Step 3 Run Application

```bash
npm start
```

Open

```
http://localhost:3000
```

Verify that the React application is running.

---

# Step 4 Dockerize Application

Dockerfile

```dockerfile
FROM node:20

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm","start"]
```

Build Docker Image

```bash
docker build -t brain-task-app .
```

Check Images

```bash
docker images
```

Run Container

```bash
docker run -d -p 3000:3000 brain-task-app
```

Open

```
http://localhost:3000
```

---

# Step 5 Create Amazon ECR Repository

Repository Name

```
brain-task-app
```

Login to ECR

```bash
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 095907291932.dkr.ecr.us-west-2.amazonaws.com
```

Tag Image

```bash
docker tag brain-task-app:latest 095907291932.dkr.ecr.us-west-2.amazonaws.com/brain-task-app:latest
```

Push Image

```bash
docker push 095907291932.dkr.ecr.us-west-2.amazonaws.com/brain-task-app:latest
```

---

# Step 6 Create Amazon EKS Cluster

Create EKS Cluster

```
Cluster Name : brain-cluster
Region : us-west-2
```

Update kubeconfig

```bash
aws eks update-kubeconfig --region us-west-2 --name brain-cluster
```

Verify Nodes

```bash
kubectl get nodes
```

Expected Output

```
Ready
Ready
```

---

# Step 7 Kubernetes Deployment

deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment

metadata:
  name: brain-task-app

spec:
  replicas: 2

  selector:
    matchLabels:
      app: brain-task-app

  template:
    metadata:
      labels:
        app: brain-task-app

    spec:
      containers:
      - name: brain-task-app
        image: 095907291932.dkr.ecr.us-west-2.amazonaws.com/brain-task-app:latest

        imagePullPolicy: Always

        ports:
        - containerPort: 3000
```

Deploy

```bash
kubectl apply -f deployment.yaml
```

---

# Step 8 Kubernetes Service

service.yaml

```yaml
apiVersion: v1
kind: Service

metadata:
  name: brain-task-service

  annotations:
    service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing

spec:
  type: LoadBalancer

  loadBalancerClass: eks.amazonaws.com/nlb

  selector:
    app: brain-task-app

  ports:
  - port: 80
    targetPort: 3000
```

Deploy Service

```bash
kubectl apply -f service.yaml
```

Verify

```bash
kubectl get svc
```

---

# Step 9 LoadBalancer

Get External URL

```bash
kubectl get svc
```

Example

```
k8s-default-braintas-xxxxxxxx.elb.us-west-2.amazonaws.com
```

Open in Browser

```
http://LoadBalancer-DNS
```

---

# Step 10 AWS CodeBuild

Create Build Project

Project Name

```
brain-task-build
```

Environment

```
Amazon Linux

Managed Image

Privileged Mode Enabled
```

Source

```
GitHub Repository
```

---

# Step 11 buildspec.yml

```yaml
version: 0.2

phases:

  pre_build:

    commands:

      - echo Logging into Amazon ECR

      - aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 095907291932.dkr.ecr.us-west-2.amazonaws.com

  build:

    commands:

      - docker build -t brain-task-app .

      - docker tag brain-task-app:latest 095907291932.dkr.ecr.us-west-2.amazonaws.com/brain-task-app:latest

  post_build:

    commands:

      - docker push 095907291932.dkr.ecr.us-west-2.amazonaws.com/brain-task-app:latest
```

---

# Step 12 Push Code to GitHub

```bash
git add .

git commit -m "Initial Commit"

git push origin main
```

---

# Step 13 AWS CodePipeline

Pipeline Flow

```
GitHub

↓

CodePipeline

↓

CodeBuild

↓

Docker Build

↓

Push Image to Amazon ECR

↓

Deploy to Amazon EKS

↓

Application Running
```

Pipeline Name

```
brain-task-pipeline
```

---

# Step 14 CloudWatch

Monitor

- CodeBuild Logs
- CodePipeline Logs
- Application Logs

---

# Verification Commands

Check Pods

```bash
kubectl get pods
```

Check Services

```bash
kubectl get svc
```

Check Deployment

```bash
kubectl get deployments
```

Describe Service

```bash
kubectl describe svc brain-task-service
```

---

# Application URLs

Local Application

```
http://localhost:3000
```

Production Application

```
http://k8s-default-braintas-d46fd04f1a-c0f74e6de17b1b2b.elb.us-west-2.amazonaws.com/
```

---

# Screenshots

Include the following screenshots:

- GitHub Repository
- Docker Images
- Docker Container Running
- Amazon ECR Repository
- Amazon EKS Cluster
- kubectl get nodes
- kubectl get pods
- kubectl get svc
- LoadBalancer URL
- React Application Running
- CodeBuild Success
- CodePipeline Success
- CloudWatch Logs

---

# Conclusion

The React application was successfully containerized using Docker, stored in Amazon ECR, deployed on Amazon EKS using Kubernetes, and automated with AWS CodeBuild and CodePipeline. CloudWatch was used for monitoring build and deployment logs.
