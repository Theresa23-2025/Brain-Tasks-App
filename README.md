# Brain Tasks App — AWS EKS Deployment & CI/CD

## 1. Project Overview

**Brain Tasks App** is a containerized web application deployed on **Amazon EKS** using Docker, Amazon ECR, Kubernetes, and AWS Load Balancer.

This project demonstrates:

* Application containerization using Docker
* Docker image storage in Amazon ECR
* Kubernetes deployment on Amazon EKS
* Kubernetes Service with an internet-facing AWS Load Balancer
* GitHub source-code integration
* AWS CodeBuild configuration
* IAM role configuration for CodeBuild
* CloudWatch logging permissions
* Automated Docker image build and push configuration
* AWS Service Quotas management

---

# 2. Technology Stack

| Technology         | Purpose                              |
| ------------------ | ------------------------------------ |
| GitHub             | Source-code repository               |
| Git                | Version control                      |
| Docker             | Application containerization         |
| Amazon ECR         | Docker image registry                |
| Amazon EKS         | Kubernetes cluster                   |
| Kubernetes         | Application deployment/orchestration |
| AWS Load Balancer  | Public application access            |
| AWS CodeBuild      | CI build and Docker image automation |
| AWS IAM            | Access control                       |
| AWS CloudWatch     | Build/logging support                |
| AWS Service Quotas | CodeBuild concurrency management     |
| Windows CMD        | Deployment administration            |

---

# 3. Repository

GitHub repository:

**Brain Tasks App**

Repository:

`https://github.com/Theresa23-2025/Brain-Tasks-App.git`

Main branch:

`main`

Latest commit:

`ee967cb Add CodeBuild ECR buildspec`

---

# 4. Local Project Location

The project is available locally at:

```text
R:\Deploy\Brain-Tasks-App-ScreenShot\Brain-Tasks-App
```

Navigate to the project:

```cmd
cd /d R:\Deploy\Brain-Tasks-App-ScreenShot\Brain-Tasks-App
```

---

# 5. Git Repository Verification

Git remote:

```cmd
git remote -v
```

Output:

```text
origin  https://github.com/Theresa23-2025/Brain-Tasks-App.git (fetch)
origin  https://github.com/Theresa23-2025/Brain-Tasks-App.git (push)
```

Repository verification:

```cmd
git ls-remote origin
```

The main branch is synchronized with the GitHub repository.

Latest commit:

```cmd
git log -1 --oneline
```

Output:

```text
ee967cb (HEAD -> main, origin/main, origin/HEAD) Add CodeBuild ECR buildspec
```

Working tree verification:

```cmd
git status
```

Expected result:

```text
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
```

---

# 6. Docker Containerization

The application is containerized using Docker.

The Docker image is stored in Amazon ECR.

ECR repository/image:

```text
037063405138.dkr.ecr.ap-south-1.amazonaws.com/brain-tasks-app:latest
```

The Kubernetes deployment uses this image.

---

# 7. Amazon EKS Deployment

The application is deployed to an Amazon EKS cluster.

The EKS worker nodes were verified using:

```cmd
kubectl get nodes -o wide
```

Current worker nodes:

```text
ip-192-168-13-193.ap-south-1.compute.internal
ip-192-168-72-150.ap-south-1.compute.internal
```

Both nodes are in:

```text
STATUS: Ready
```

The cluster is therefore successfully running Kubernetes worker nodes.

---

# 8. Kubernetes Deployment

The application uses a Kubernetes Deployment named:

```text
brain-app
```

Deployment configuration:

```yaml
apiVersion: apps/v1
kind: Deployment

metadata:
  name: brain-app

spec:
  replicas: 2

  selector:
    matchLabels:
      app: brain-app

  template:
    metadata:
      labels:
        app: brain-app

    spec:
      containers:
      - name: brain-app
        image: 037063405138.dkr.ecr.ap-south-1.amazonaws.com/brain-tasks-app:latest
        ports:
        - containerPort: 80
```

---

# 9. Kubernetes Replicas

The application is configured with:

```text
replicas: 2
```

This provides two running application Pods.

Deployment verification:

```cmd
kubectl get deployment brain-app -o wide
```

Current status:

```text
READY         2/2
UP-TO-DATE    2
AVAILABLE     2
```

This confirms that both requested application replicas are running.

---

# 10. Kubernetes Pods

Pods were verified using:

```cmd
kubectl get pods -A
```

Application Pods:

```text
brain-app-5d9776f6d-7bccx
brain-app-5d9776f6d-jvttd
```

Both application Pods are:

```text
READY: 1/1
STATUS: Running
RESTARTS: 0
```

This confirms successful application deployment.

---

# 11. Complete Kubernetes Resource Verification

The following command was used:

```cmd
kubectl get deployment,service,pods -o wide
```

Current application deployment:

```text
deployment.apps/brain-app
```

Current application service:

```text
service/brain-task-service
```

Current application Pods:

```text
pod/brain-app-5d9776f6d-7bccx
pod/brain-app-5d9776f6d-jvttd
```

---

# 12. Kubernetes Service

The application is exposed using a Kubernetes `LoadBalancer` Service.

Service configuration:

```yaml
apiVersion: v1
kind: Service

metadata:
  name: brain-task-service
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing

spec:
  type: LoadBalancer

  selector:
    app: brain-app

  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```

Important configuration:

```text
Type: LoadBalancer
Port: 80
TargetPort: 80
Scheme: internet-facing
```

---

# 13. AWS Load Balancer

The Kubernetes LoadBalancer created an AWS Elastic Load Balancer.

Load Balancer DNS:

```text
a6541b307a7f14a32b3390c165e7de3d-488304798.ap-south-1.elb.amazonaws.com
```

The Load Balancer is:

```text
internet-facing
```

AWS Classic Load Balancer verification:

```cmd
aws elb describe-load-balancers --load-balancer-name a6541b307a7f14a32b3390c165e7de3d --region ap-south-1 --output json
```

Important details:

```text
LoadBalancerName:
a6541b307a7f14a32b3390c165e7de3d

DNSName:
a6541b307a7f14a32b3390c165e7de3d-488304798.ap-south-1.elb.amazonaws.com

Scheme:
internet-facing
```

---

# 14. Load Balancer Listener

The AWS Load Balancer has the following listener:

```text
Protocol: TCP
Load Balancer Port: 80
Instance Protocol: TCP
Instance Port: 31413
```

The Kubernetes Service uses NodePort:

```text
31413
```

Therefore traffic flows approximately as:

```text
Internet
   |
   v
AWS Load Balancer :80
   |
   v
Kubernetes NodePort :31413
   |
   v
Brain Tasks App Pods :80
```

---

# 15. Kubernetes Service Verification

Command:

```cmd
kubectl get service brain-task-service
```

Current result includes:

```text
TYPE: LoadBalancer
CLUSTER-IP: 10.100.130.177
EXTERNAL-IP:
a6541b307a7f14a32b3390c165e7de3d-488304798.ap-south-1.elb.amazonaws.com

PORT(S):
80:31413/TCP
```

---

# 16. Service Detailed Verification

Command:

```cmd
kubectl describe service brain-task-service
```

Important configuration:

```text
Type: LoadBalancer

Selector:
app=brain-app

Port:
80/TCP

TargetPort:
80/TCP

NodePort:
31413

Endpoints:
192.168.83.211:80
192.168.79.116:80
```

The endpoints correspond to the two running application Pods.

This confirms that the Service successfully discovers the application Pods.

---

# 17. Public Application Connectivity Test

The public Load Balancer endpoint was tested using:

```cmd
curl -I http://a6541b307a7f14a32b3390c165e7de3d-488304798.ap-south-1.elb.amazonaws.com
```

Result:

```text
HTTP/1.1 200 OK
Server: nginx/1.31.3
Content-Type: text/html
Connection: keep-alive
```

Therefore the application is successfully reachable through the public AWS Load Balancer.

---

# 18. Application Deployment Status

Current Kubernetes deployment status:

```text
Deployment:
brain-app

Replicas:
2

Ready:
2/2

Available:
2

Pods:
2

Pod Status:
Running

Service:
brain-task-service

Service Type:
LoadBalancer

Load Balancer:
internet-facing

Application HTTP Status:
200 OK
```

---

# 19. BuildSpec for AWS CodeBuild

A `buildspec.yml` file was added to the project.

Current file:

```yaml
version: 0.2

phases:
  install:
    commands:
      - echo "Install Phase"

  pre_build:
    commands:
      - echo "Logging in to Amazon ECR"
      - aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 037063405138.dkr.ecr.ap-south-1.amazonaws.com

  build:
    commands:
      - echo "Build Started"
      - docker build -t brain-tasks-app .
      - docker tag brain-tasks-app:latest 037063405138.dkr.ecr.ap-south-1.amazonaws.com/brain-tasks-app:latest

  post_build:
    commands:
      - echo "Push Image"
      - docker push 037063405138.dkr.ecr.ap-south-1.amazonaws.com/brain-tasks-app:latest

artifacts:
  files:
    - '**/*'
```

---

# 20. CodeBuild Build Process

The CodeBuild configuration performs the following process:

```text
GitHub
   |
   v
AWS CodeBuild
   |
   v
Docker Build
   |
   v
Docker Image
   |
   v
Amazon ECR
   |
   v
brain-tasks-app:latest
```

The build process consists of:

### Install

```text
Install Phase
```

### Pre-build

Authenticate Docker with Amazon ECR:

```cmd
aws ecr get-login-password --region ap-south-1
```

### Build

Build Docker image:

```cmd
docker build -t brain-tasks-app .
```

Tag image:

```cmd
docker tag brain-tasks-app:latest 037063405138.dkr.ecr.ap-south-1.amazonaws.com/brain-tasks-app:latest
```

### Post-build

Push image:

```cmd
docker push 037063405138.dkr.ecr.ap-south-1.amazonaws.com/brain-tasks-app:latest
```

---

# 21. Git Commit for CodeBuild BuildSpec

The CodeBuild buildspec was committed to GitHub.

Commit:

```text
ee967cb Add CodeBuild ECR buildspec
```

Git verification:

```cmd
git log -1 --oneline
```

Result:

```text
ee967cb (HEAD -> main, origin/main, origin/HEAD) Add CodeBuild ECR buildspec
```

The working tree is clean.

---

# 22. AWS IAM CodeBuild Role

An IAM role was created for AWS CodeBuild.

Role name:

```text
BrainTasksCodeBuildRole
```

Role ARN:

```text
arn:aws:iam::037063405138:role/BrainTasksCodeBuildRole
```

The role trust policy allows:

```text
codebuild.amazonaws.com
```

to assume the role.

---

# 23. CodeBuild IAM Policies

The following policies were attached to:

```text
BrainTasksCodeBuildRole
```

### Amazon ECR

```text
AmazonEC2ContainerRegistryPowerUser
```

Purpose:

* Authenticate with ECR
* Build/push Docker images
* Access ECR repositories

### CloudWatch

```text
CloudWatchLogsFullAccess
```

Purpose:

* CodeBuild logging
* CloudWatch log integration

### Amazon S3

```text
AmazonS3ReadOnlyAccess
```

Purpose:

* Read required S3 resources

---

# 24. IAM Policy Verification

Command:

```cmd
aws iam list-attached-role-policies --role-name BrainTasksCodeBuildRole --output table
```

Configured policies:

```text
AmazonEC2ContainerRegistryPowerUser
CloudWatchLogsFullAccess
AmazonS3ReadOnlyAccess
```

---

# 25. CodeBuild Project

A CodeBuild project named:

```text
brain-tasks-build
```

was created.

Project ARN:

```text
arn:aws:codebuild:ap-south-1:037063405138:project/brain-tasks-build
```

---

# 26. CodeBuild Source

Source provider:

```text
GitHub
```

Repository:

```text
https://github.com/Theresa23-2025/Brain-Tasks-App.git
```

BuildSpec:

```text
buildspec.yml
```

Git clone depth:

```text
1
```

---

# 27. CodeBuild Environment

CodeBuild environment:

```text
Environment:
LINUX_CONTAINER
```

Build image:

```text
aws/codebuild/standard:7.0
```

Compute type:

```text
BUILD_GENERAL1_SMALL
```

Privileged mode:

```text
True
```

Privileged mode is required because the build process performs Docker operations.

---

# 28. CodeBuild Environment Variables

Configured environment variables:

```text
AWS_DEFAULT_REGION=ap-south-1
```

and:

```text
AWS_ACCOUNT_ID=037063405138
```

---

# 29. CodeBuild Artifacts

CodeBuild artifacts configuration:

```text
NO_ARTIFACTS
```

The purpose of this project is to build and push the Docker image to Amazon ECR, so a separate build artifact is not required.

---

# 30. CodeBuild Project Verification

Command:

```cmd
aws codebuild batch-get-projects --names brain-tasks-build --region ap-south-1 --query "projects[0].{Name:name,Source:source.location,Buildspec:source.buildspec,Image:environment.image,ComputeType:environment.computeType,PrivilegedMode:environment.privilegedMode,ServiceRole:serviceRole,Artifacts:artifacts.type}" --output table
```

Verified configuration:

```text
Name:
brain-tasks-build

Source:
https://github.com/Theresa23-2025/Brain-Tasks-App.git

Buildspec:
buildspec.yml

Image:
aws/codebuild/standard:7.0

ComputeType:
BUILD_GENERAL1_SMALL

PrivilegedMode:
True

ServiceRole:
arn:aws:iam::037063405138:role/BrainTasksCodeBuildRole

Artifacts:
NO_ARTIFACTS
```

---

# 31. CodeBuild Execution Issue

An attempt was made to start the CodeBuild project:

```cmd
aws codebuild start-build --project-name brain-tasks-build --region ap-south-1
```

AWS returned:

```text
AccountLimitExceededException:
Cannot have more than 0 builds in queue for the account
```

This is not a project configuration error.

The AWS account currently has a CodeBuild concurrency quota of:

```text
0
```

Therefore CodeBuild cannot start a build until the quota is increased.

---

# 32. CodeBuild Build History Verification

Command:

```cmd
aws codebuild list-builds --region ap-south-1
```

Result:

```json
{
    "ids": []
}
```

Project-specific check:

```cmd
aws codebuild list-builds-for-project --project-name brain-tasks-build --region ap-south-1
```

Result:

```json
{
    "ids": []
}
```

This confirms that no CodeBuild execution has started yet.

---

# 33. AWS CodeBuild Service Quota

The relevant quota is:

```text
Concurrently running builds for Linux/Small environment
```

Quota code:

```text
L-9D07B6EF
```

Current value:

```text
0
```

Required value:

```text
1
```

---

# 34. CodeBuild Quota Increase Request

A quota increase request was successfully submitted:

```cmd
aws service-quotas request-service-quota-increase --service-code codebuild --quota-code L-9D07B6EF --desired-value 1 --region ap-south-1
```

Request ID:

```text
4b0d788fc43f455ea4015cd43bab2326855Cy4Lj
```

Case ID:

```text
178946621600429
```

Desired quota:

```text
1
```

Current request status:

```text
CASE_OPENED
```

---

# 35. Checking CodeBuild Quota Request

Use:

```cmd
aws service-quotas get-requested-service-quota-change --request-id 4b0d788fc43f455ea4015cd43bab2326855Cy4Lj --region ap-south-1
```

Current status:

```text
CASE_OPENED
```

This means AWS has opened the support case/request and the quota increase is still pending.

---

# 36. Important Quota Limitation

Do **not** submit another request for the same quota while the existing request is open.

Attempting:

```cmd
aws service-quotas request-service-quota-increase --service-code codebuild --quota-code L-9D07B6EF --desired-value 2 --region ap-south-1
```

returns:

```text
ResourceAlreadyExistsException:
Only one open service quota increase request is allowed per quota.
```

Therefore the existing request must be processed first.

---

# 37. Checking Current Approved Quota

Use:

```cmd
aws service-quotas get-service-quota --service-code codebuild --quota-code L-9D07B6EF --region ap-south-1 --query "Quota.Value" --output text
```

Current value:

```text
0.0
```

The CodeBuild quota has therefore **not yet been approved**.

---

# 38. CodeBuild Current Status

The CodeBuild component is currently:

```text
CONFIGURED
```

but:

```text
EXECUTION PENDING
```

because AWS CodeBuild concurrency is currently:

```text
0
```

The following components are already configured:

* IAM CodeBuild role
* ECR permissions
* CloudWatch permissions
* S3 read permissions
* GitHub source
* CodeBuild project
* BuildSpec
* Docker build commands
* ECR login
* ECR push commands
* Privileged Docker build environment

Only the actual CodeBuild execution remains blocked by the AWS quota.

---

# 39. Overall Architecture

```text
                         GitHub
                           |
                           |
                           v
                 +-------------------+
                 |    AWS CodeBuild  |
                 | brain-tasks-build |
                 +-------------------+
                           |
                     Docker Build
                           |
                           v
                 +-------------------+
                 |    Amazon ECR     |
                 | brain-tasks-app   |
                 +-------------------+
                           |
                           |
                           v
                    Amazon EKS
                 +-------------------+
                 |   brain-app       |
                 |   Deployment      |
                 |   2 Replicas      |
                 +-------------------+
                     /          \
                    /            \
                   v              v
              Pod Replica 1   Pod Replica 2
                    \            /
                     \          /
                      v        v
                 Kubernetes Service
                 brain-task-service
                         |
                         v
               AWS Load Balancer
                  Port 80
                         |
                         v
                    Internet
```

---

# 40. Current Project Status

| Component                      | Status            |
| ------------------------------ | ----------------- |
| GitHub Repository              | ✅ Completed       |
| Git Branch                     | ✅ Completed       |
| Git Working Tree               | ✅ Clean           |
| Dockerfile                     | ✅ Completed       |
| Docker Containerization        | ✅ Completed       |
| Amazon ECR Image               | ✅ Configured/Used |
| EKS Cluster                    | ✅ Running         |
| EKS Worker Nodes               | ✅ Ready           |
| Kubernetes Deployment          | ✅ Completed       |
| Kubernetes Replicas            | ✅ 2/2 Running     |
| Kubernetes Service             | ✅ Completed       |
| AWS Load Balancer              | ✅ Completed       |
| Internet-Facing Access         | ✅ Completed       |
| Application HTTP Test          | ✅ `200 OK`        |
| CodeBuild IAM Role             | ✅ Completed       |
| CodeBuild IAM Policies         | ✅ Completed       |
| CodeBuild Project              | ✅ Created         |
| CodeBuild BuildSpec            | ✅ Completed       |
| GitHub → CodeBuild Source      | ✅ Configured      |
| Docker Build in CodeBuild      | ✅ Configured      |
| ECR Push in CodeBuild          | ✅ Configured      |
| CodeBuild Execution            | ⏳ Pending         |
| CodeBuild Quota                | ⏳ Pending         |
| Quota Approval                 | ⏳ `CASE_OPENED`   |
| Automated CodeBuild → ECR Test | ⏳ Pending         |

---

# 41. Remaining Steps

Only the following steps remain for the CodeBuild portion.

### Step 1 — Wait for quota approval

Check:

```cmd
aws service-quotas get-requested-service-quota-change --request-id 4b0d788fc43f455ea4015cd43bab2326855Cy4Lj --region ap-south-1
```

Wait until the status changes from:

```text
CASE_OPENED
```

to an approved/completed state.

---

### Step 2 — Verify quota

After approval:

```cmd
aws service-quotas get-service-quota --service-code codebuild --quota-code L-9D07B6EF --region ap-south-1 --query "Quota.Value" --output text
```

Expected:

```text
1.0
```

---

### Step 3 — Start CodeBuild

After the quota becomes `1`:

```cmd
aws codebuild start-build --project-name brain-tasks-build --region ap-south-1
```

---

### Step 4 — Get build ID

```cmd
aws codebuild list-builds-for-project --project-name brain-tasks-build --region ap-south-1
```

---

### Step 5 — Check build status

```cmd
aws codebuild batch-get-builds --ids BUILD_ID --region ap-south-1 --query "builds[0].{Status:buildStatus,Phase:currentPhase,Start:startTime,End:endTime}" --output table
```

Expected successful status:

```text
SUCCEEDED
```

---

### Step 6 — Verify ECR image

After successful CodeBuild execution:

```cmd
aws ecr describe-images --repository-name brain-tasks-app --region ap-south-1 --query "imageDetails[].{Tags:imageTags,Pushed:imagePushedAt}" --output table
```

Verify that:

```text
latest
```

exists.

---

# 42. Final Deployment Flow

The final intended CI/CD flow is:

```text
Developer
    |
    v
GitHub main branch
    |
    v
AWS CodeBuild
    |
    +---- Docker Build
    |
    +---- Docker Tag
    |
    +---- ECR Login
    |
    v
Amazon ECR
    |
    v
Docker Image
    |
    v
Amazon EKS
    |
    v
Kubernetes Deployment
    |
    v
2 Application Pods
    |
    v
Kubernetes LoadBalancer Service
    |
    v
AWS Internet-Facing Load Balancer
    |
    v
Public Application
```

---

# 43. Verification Commands

## Check Git

```cmd
git status
git log -1 --oneline
```

## Check EKS nodes

```cmd
kubectl get nodes -o wide
```

## Check Pods

```cmd
kubectl get pods -A
```

## Check Deployment

```cmd
kubectl get deployment brain-app -o wide
```

## Check Deployment Image

```cmd
kubectl get deployment brain-app -o jsonpath="{.spec.template.spec.containers[0].image}"
```

## Check Services

```cmd
kubectl get service brain-task-service
```

## Check Service Details

```cmd
kubectl describe service brain-task-service
```

## Check Complete Kubernetes Deployment

```cmd
kubectl get deployment,service,pods -o wide
```

## Get Load Balancer DNS

```cmd
kubectl get service brain-task-service -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"
```

## Test Application

```cmd
curl -I http://a6541b307a7f14a32b3390c165e7de3d-488304798.ap-south-1.elb.amazonaws.com
```

## Check CodeBuild Project

```cmd
aws codebuild batch-get-projects --names brain-tasks-build --region ap-south-1
```

## Check CodeBuild Builds

```cmd
aws codebuild list-builds --region ap-south-1
```

## Check Project Builds

```cmd
aws codebuild list-builds-for-project --project-name brain-tasks-build --region ap-south-1
```

## Check CodeBuild Quota

```cmd
aws service-quotas get-service-quota --service-code codebuild --quota-code L-9D07B6EF --region ap-south-1 --query "Quota.Value" --output text
```

## Check Quota Request

```cmd
aws service-quotas get-requested-service-quota-change --request-id 4b0d788fc43f455ea4015cd43bab2326855Cy4Lj --region ap-south-1
```

---

# 44. Conclusion

The Brain Tasks App has been successfully containerized and deployed to Amazon EKS.

The Kubernetes infrastructure is operational with:

* 2 EKS worker nodes in `Ready` state
* 2 application replicas in `Running` state
* Kubernetes Deployment successfully configured
* Kubernetes LoadBalancer Service successfully configured
* Internet-facing AWS Load Balancer successfully created
* Public HTTP endpoint successfully responding with `200 OK`

The AWS CodeBuild CI/CD infrastructure has also been configured:

* GitHub repository connected
* CodeBuild project created
* IAM service role created
* ECR permissions configured
* CloudWatch permissions configured
* S3 permissions configured
* Docker privileged mode enabled
* `buildspec.yml` configured
* ECR build and push commands configured

The **only remaining blocker is AWS CodeBuild concurrency quota approval**.

Current quota request:

```text
Quota:
Concurrently running builds for Linux/Small environment

Quota Code:
L-9D07B6EF

Current:
0

Requested:
1

Request Status:
CASE_OPENED

Case ID:
178946621600429
```

Once AWS approves the quota increase to `1`, the CodeBuild project can be executed and the final **GitHub → CodeBuild → Docker → ECR** automation can be verified.

---

## Project Completion Summary

```text
GitHub Repository                  ✅
        |
        v
Docker Containerization            ✅
        |
        v
Amazon ECR                         ✅
        |
        v
Amazon EKS                         ✅
        |
        v
Kubernetes Deployment              ✅
        |
        v
2 Running Pods                     ✅
        |
        v
LoadBalancer Service               ✅
        |
        v
Internet-Facing AWS Load Balancer  ✅
        |
        v
Public Application                 ✅  HTTP 200
        |
        v
CodeBuild IAM Role                 ✅
        |
        v
CodeBuild Project                  ✅
        |
        v
buildspec.yml                      ✅
        |
        v
CodeBuild Execution                ⏳
        |
        v
Quota Approval                     ⏳
```

