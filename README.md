# 🧠 Brain Tasks App

A modern task management web application deployed using a complete DevOps workflow with **GitHub, Jenkins, Docker, Nginx, GitHub Pages, and AWS ECR**.

The project demonstrates source-code management, automated CI/CD, containerization, web-server deployment, and public static hosting.

---

## 🌐 Live Demo

### 🚀 Brain Tasks App

**Live Application:**  
https://theresa23-2025.github.io/Brain-Tasks-App/

**GitHub Repository:**  
https://github.com/Theresa23-2025/Brain-Tasks-App

---

## 📌 Project Overview

**Brain Tasks App** is a task management web application designed to provide a simple and responsive interface for organizing tasks.

The application includes a clean dashboard where tasks can be viewed, searched, and filtered based on their status.

This project also demonstrates a complete deployment workflow using modern DevOps tools.

### Deployment workflow

```text
Developer
    ↓
Git
    ↓
GitHub Repository
    ↓
Jenkins CI/CD
    ↓
Docker Build
    ↓
Nginx Container
    ↓
Local Deployment
```

For public hosting:

```text
GitHub Repository
    ↓
dist/
    ↓
gh-pages Branch
    ↓
GitHub Pages
    ↓
Public Live Application
```

---

# ✨ Application Features

The Brain Tasks App provides the following user interface features:

- Task management dashboard
- Create Task interface
- Task search
- All Tasks filter
- Pending Tasks filter
- Completed Tasks filter
- Priority Tasks filter
- Responsive user interface
- Clean task management layout

---

# 🛠️ Technology Stack

| Technology | Purpose |
|---|---|
| Git | Version control |
| GitHub | Remote source-code repository |
| Jenkins | CI/CD automation |
| Jenkinsfile | Declarative CI/CD pipeline definition |
| AWS ECR | Docker image registry |
| Poll SCM | Automatic Git change detection |
| Docker | Application containerization |
| Docker Compose | Container configuration |
| Nginx | Production web server |
| GitHub Pages | Public static hosting |
| React Router | Client-side routing |
| GitHub `main` Branch | Main project version |
| GitHub `gh-pages` Branch | Public deployment version |

---

# 🏗️ Deployment Architecture

```text
                     ┌──────────────────────┐
                     │      Developer       │
                     └──────────┬───────────┘
                                │
                                │ Git Push
                                ▼
                     ┌──────────────────────┐
                     │  GitHub Repository   │
                     │     main branch      │
                     └──────────┬───────────┘
                                │
                ┌───────────────┴────────────────┐
                │                                │
                ▼                                ▼
      ┌──────────────────┐             ┌──────────────────┐
      │     Jenkins      │             │   dist Folder    │
      │      CI/CD       │             └────────┬─────────┘
      └────────┬─────────┘                      │
               │                                ▼
               │                       ┌──────────────────┐
               │                       │ gh-pages Branch  │
               ▼                       └────────┬─────────┘
      ┌──────────────────┐                      │
      │   Docker Build   │                      ▼
      └────────┬─────────┘             ┌──────────────────┐
               │                       │   GitHub Pages   │
               ▼                       └────────┬─────────┘
      ┌──────────────────┐                      │
      │ Nginx Container  │                      ▼
      └────────┬─────────┘             ┌──────────────────┐
               │                       │ Public Live App  │
               ▼                       └──────────────────┘
      ┌──────────────────┐
      │ localhost:8080   │
      └──────────────────┘
```

---

# 🔄 Complete CI/CD Workflow

The project uses GitHub, Jenkins, and Docker to create an automated deployment workflow.

## 1. Developer Updates Project

Application files are maintained in the local project directory.

```text
R:\Deploy\Therasha\Brain-Tasks-App
```

After making changes, Git is used to track the modifications.

---

## 2. Git Version Control

Check project status:

```bash
git status
```

Stage changes:

```bash
git add .
```

Commit changes:

```bash
git commit -m "Update Brain Tasks App"
```

Push changes:

```bash
git push origin main
```

The latest version is then available in the GitHub `main` branch.

---

## 3. GitHub Repository

GitHub acts as the central source-code repository for the project.

### Repository

```text
https://github.com/Theresa23-2025/Brain-Tasks-App
```

### Main Branch

```text
main
```

The `main` branch contains the primary project and deployment configuration.

### Deployment Branch

```text
gh-pages
```

The `gh-pages` branch contains the static production files used for the public GitHub Pages deployment.

---

# ⚙️ Jenkins CI/CD

Jenkins is used as the Continuous Integration and Continuous Deployment automation server.

### Jenkins URL

```text
http://localhost:8081
```

Jenkins performs the following deployment operations:

1. Checks the GitHub repository.
2. Detects changes in the `main` branch.
3. Retrieves the latest project version.
4. Builds the Docker image.
5. Removes/replaces the previous application container when required.
6. Starts the latest Docker container.
7. Serves the application through Nginx.
8. Makes the local deployment available through port `8080`.

---

# 🚀 Jenkins Declarative Pipeline

The `Jenkinsfile` is tracked in the GitHub `main` branch. The Jenkins Pipeline job is named **`brain-tasks-pipeline`**.

| Stage | Action |
|---|---|
| Checkout | Retrieves source code using `checkout scm` |
| Verify Docker | Runs Docker version and container checks |
| Stop Old Container | Removes `brain-tasks-live` if present |
| Build Docker Image | Builds `brain-tasks-app:latest` |
| Deploy Container | Starts `brain-tasks-live` with port mapping `8080:80` |
| Verify Deployment | Lists Docker containers matching the application name |

The `post` section logs success, failure, and completion messages. A Jenkins Pipeline run completed successfully and reported the application at `http://localhost:8080`.

**Scope:** This pipeline builds and deploys Docker **locally**. It does not currently push an image to AWS ECR or deploy to AWS EKS. The container-list check does not by itself confirm HTTP application health.

---

# 🔁 Jenkins Poll SCM

Jenkins Poll SCM is configured to automatically check the GitHub repository for changes.

### Poll SCM Schedule

```text
H/5 * * * *
```

This configuration allows Jenkins to periodically check the repository.

The workflow becomes:

```text
Code Change
    ↓
Git Commit
    ↓
Git Push
    ↓
GitHub main Branch
    ↓
Jenkins Poll SCM
    ↓
Change Detected
    ↓
Automatic Jenkins Build
    ↓
Docker Image Build
    ↓
Container Deployment
```

This removes the need to manually trigger Jenkins after every Git push.

---

# 🐳 Docker Containerization

Docker is used to package and run the production application.

The application uses an Nginx-based Docker image.

### Docker Version Used

```text
Docker 29.8.2
```

---

# 📄 Dockerfile

The project uses the following Dockerfile:

```dockerfile
FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

COPY dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

---

## Dockerfile Explanation

### Base Image

```dockerfile
FROM nginx:alpine
```

Uses the lightweight Alpine-based Nginx image.

### Remove Default Nginx Files

```dockerfile
RUN rm -rf /usr/share/nginx/html/*
```

Removes the default Nginx HTML files.

### Copy Application

```dockerfile
COPY dist /usr/share/nginx/html
```

Copies the production build from the `dist` directory into the Nginx web root.

### Expose Port

```dockerfile
EXPOSE 80
```

The Nginx server listens on port `80` inside the Docker container.

### Start Nginx

```dockerfile
CMD ["nginx", "-g", "daemon off;"]
```

Starts Nginx in the foreground when the container starts.

---

# 🌐 Nginx Web Server

Nginx is used to serve the production frontend application inside the Docker container.

The application files are served from:

```text
/usr/share/nginx/html
```

Internal container port:

```text
80
```

Host port:

```text
8080
```

Therefore, the local Docker application is available at:

```text
http://localhost:8080
```

---

# 🐳 Docker Compose

The project includes a `docker-compose.yml` file.

```yaml
version: '3.8'

services:
  brain-tasks-app:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "8080:80"
    restart: unless-stopped
```

### Port Mapping

| Environment | Port |
|---|---:|
| Host Machine | `8080` |
| Docker Container | `80` |

Mapping:

```text
8080:80
```

---

# 🚀 Manual Docker Deployment

Build the Docker image:

```bash
docker build -t brain-tasks-app .
```

Run the application:

```bash
docker run -d --name brain-tasks-live -p 8080:80 brain-tasks-app
```

Check running containers:

```bash
docker ps
```

Open the local application:

```text
http://localhost:8080
```

Stop the container:

```bash
docker stop brain-tasks-live
```

Remove the container:

```bash
docker rm brain-tasks-live
```

---

# 🔗 Jenkins and Docker Integration

Jenkins runs as a Windows service using the `LocalSystem` account.

The Docker executable used by Jenkins is:

```text
C:\Users\1crore\AppData\Local\Programs\DockerDesktop\resources\bin\docker.exe
```

Docker can be verified from Jenkins using:

```bat
"C:\Users\1crore\AppData\Local\Programs\DockerDesktop\resources\bin\docker.exe" --version
```

Running containers can be checked using:

```bat
"C:\Users\1crore\AppData\Local\Programs\DockerDesktop\resources\bin\docker.exe" ps
```

This allows Jenkins to communicate with Docker Desktop and perform automated container deployments.

---

# 🌍 GitHub Pages Deployment

GitHub Pages provides the public deployment URL for the Brain Tasks frontend.

The production build is located inside:

```text
dist/
```

The `dist` directory is published to:

```text
gh-pages
```

using:

```bash
git subtree push --prefix dist origin gh-pages
```

---

# ⚙️ GitHub Pages Configuration

GitHub Pages is configured with:

| Setting | Value |
|---|---|
| Source | Deploy from a branch |
| Branch | `gh-pages` |
| Folder | `/(root)` |

### Public Live URL

```text
https://theresa23-2025.github.io/Brain-Tasks-App/
```

---

# 🛣️ React Router Configuration

The application uses client-side routing.

GitHub Pages hosts the project under:

```text
/Brain-Tasks-App/
```

Therefore, the deployed router is configured with the project basename:

```text
basename="/Brain-Tasks-App"
```

This allows the application to correctly recognize the GitHub Pages project path.

The application contains routes including:

```text
/
/createTask
/updateTask/:id
```

---

# 📦 GitHub Pages Asset Configuration

The application JavaScript and CSS files are located inside:

```text
dist/assets/
```

The deployed `index.html` uses project-relative asset paths.

Example:

```html
<script
  type="module"
  crossorigin
  src="./assets/index-BHGiHu50.js">
</script>

<link
  rel="stylesheet"
  crossorigin
  href="./assets/index-DPTLVrPB.css"
/>
```

Relative asset paths ensure the production assets are loaded correctly from the GitHub Pages project directory.

---

# ☁️ AWS ECR — Docker Image Registry

An AWS Elastic Container Registry (ECR) repository named **`brain-tasks-app`** was created in the **`ap-southeast-2`** region. A Docker image with tag **`latest`** was uploaded successfully.

| Setting | Recorded value |
|---|---|
| Service | Amazon Elastic Container Registry (ECR) |
| Repository | `brain-tasks-app` |
| AWS Region | `ap-southeast-2` (Sydney) |
| Image Tag | `latest` |
| Upload Status | Completed |
| Evidence | `ScreenShot/10-AWS-ECR-Docker-Image.png` |

The full ECR registry URI/account ID is intentionally omitted here because it was not provided in the verified project details. The AWS ECR upload was completed separately from the local Jenkinsfile pipeline.

---

# ☸️ AWS EKS — Attempted, Not Deployed

An EKS cluster named **`brain-tasks-cluster`** was created during exploration. The managed node group did not join the Kubernetes cluster successfully (`NodeCreationFailure`). An earlier instance-type selection was also unsuitable for the intended Free Tier setup.

To avoid ongoing AWS costs, the EKS cluster was **deleted**. Therefore:

- **EKS production deployment:** Not completed
- **Kubernetes worker nodes:** Not operational
- **AWS Load Balancer:** Not deployed
- **CloudWatch application monitoring:** Not configured
- **AWS ECR image:** Retained in the repository

The working application deployments are the local Docker/Nginx container and the public GitHub Pages site. Do not describe EKS as a successful deployment.

---

# 📂 Project Structure

```text
Brain-Tasks-App/
│
├── dist/
│   │
│   ├── index.html
│   ├── vite.svg
│   │
│   └── assets/
│       ├── index-BHGiHu50.js
│       └── index-DPTLVrPB.css
│
├── ScreenShot/
│
├── .dockerignore
├── docker-compose.yml
├── Dockerfile
├── Jenkinsfile
└── README.md
```

---

# 🚀 Complete Deployment Procedure

## Step 1 — Check Changes

```bash
git status
```

## Step 2 — Stage Changes

```bash
git add .
```

## Step 3 — Commit

```bash
git commit -m "Update Brain Tasks App"
```

## Step 4 — Push to GitHub

```bash
git push origin main
```

## Step 5 — Jenkins Detects Changes

Jenkins Poll SCM checks GitHub and automatically starts a deployment when a new commit is detected.

## Step 6 — Docker Deployment

Jenkins builds the latest Docker image and starts the application container.

Local deployment:

```text
http://localhost:8080
```

## Step 7 — Publish GitHub Pages

Publish the production `dist` directory:

```bash
git subtree push --prefix dist origin gh-pages
```

## Step 8 — Public Deployment

Open:

```text
https://theresa23-2025.github.io/Brain-Tasks-App/
```

---

# 🔍 Deployment Verification

## Verify Public Website

```bash
curl -I https://theresa23-2025.github.io/Brain-Tasks-App/
```

Successful response:

```text
HTTP/1.1 200 OK
```

## Verify JavaScript Asset

```bash
curl -I https://theresa23-2025.github.io/Brain-Tasks-App/
```

For JavaScript assets, inspect the current deployed `index.html` and test its actual `assets/` URL; hashed filenames can change with new builds.

```bash
# Example only; replace with the current hashed filename
curl -I https://theresa23-2025.github.io/Brain-Tasks-App/assets/<current-file>.js
```

Successful response:

```text
HTTP/1.1 200 OK
```

---

# 🧰 Tools Used

## Git

Used for:

- Version control
- Tracking project changes
- Creating commits
- Managing branches
- Pushing code to GitHub

## GitHub

Used for:

- Remote source-code storage
- Main project branch
- Deployment branch
- GitHub Pages hosting

## Jenkins

Used for:

- CI/CD automation
- Repository monitoring
- Automatic build triggering
- Docker build execution
- Local application deployment

## Jenkins Poll SCM

Used for:

- Periodically checking GitHub
- Detecting new commits
- Automatically triggering Jenkins builds

## Docker

Used for:

- Containerization
- Packaging the application
- Creating a reproducible deployment environment

## Docker Compose

Used for:

- Defining the application container
- Port mapping
- Container restart configuration

## Nginx

Used for:

- Serving production frontend files
- Running the web application inside Docker

## GitHub Pages

Used for:

- Public static application hosting
- Providing the permanent public project URL

## React Router

Used for:

- Frontend routing
- Navigation between application pages
- GitHub Pages project-path routing

---

# 🔧 Troubleshooting

## GitHub Pages Shows a Blank Page

Check the browser Developer Tools Console.

If the following appears:

```text
No routes matched location "/Brain-Tasks-App/"
```

verify that the router uses:

```text
basename="/Brain-Tasks-App"
```

---

## CSS or JavaScript Does Not Load

Verify the production asset paths.

Correct:

```text
./assets/
```

Incorrect for this project deployment:

```text
/assets/
```

---

## Jenkins Cannot Find Docker

If Jenkins cannot recognize the `docker` command, use the full Docker executable path:

```text
C:\Users\1crore\AppData\Local\Programs\DockerDesktop\resources\bin\docker.exe
```

---

## Check Docker Containers

```bash
docker ps
```

The Brain Tasks application container should appear in the running container list.

---

## GitHub Pages Does Not Show Latest Changes

Publish the latest production files again:

```bash
git subtree push --prefix dist origin gh-pages
```

After deployment completes, perform a browser hard refresh:

```text
Ctrl + F5
```

---

# 🔐 Branch Strategy

| Branch | Purpose |
|---|---|
| `main` | Main project and deployment configuration |
| `gh-pages` | Production files for public GitHub Pages deployment |

---

# 📊 Deployment Summary

| Component | Status | Purpose |
|---|---|---|
| Git |  Working | Version control |
| GitHub |  Working | Source repository |
| Jenkins |  Working | CI/CD automation |
| Jenkinsfile Pipeline | Successful run | Local Docker deployment |
| AWS ECR | Image uploaded | Docker image registry |
| AWS EKS | Not deployed; cluster deleted | Attempted Kubernetes deployment |
| AWS Load Balancer | Not deployed | No active load balancer |
| CloudWatch Monitoring | Not configured | No application monitoring setup |
| Poll SCM |  Working | Automatic change detection |
| Docker |  Working | Containerization |
| Nginx |  Working | Web server |
| Local Deployment |  Working | Docker-hosted application |
| GitHub Pages |  Working | Public hosting |
| React Router |  Configured | GitHub Pages routing |
| Public Deployment |  Live | Production application |

---

# 🔗 Important URLs

### GitHub Repository

```text
https://github.com/Theresa23-2025/Brain-Tasks-App
```

### Public Live Application

```text
https://theresa23-2025.github.io/Brain-Tasks-App/
```

### Jenkins Dashboard

```text
http://localhost:8081
```

### Local Docker Deployment

```text
http://localhost:8080
```

---

#  Final Deployment Status

The **local Docker/Nginx CI/CD workflow and public GitHub Pages deployment** have been successfully completed. AWS ECR image upload is complete; AWS EKS deployment was attempted but not completed.

### Completed

-  Git repository configured
-  GitHub repository connected
-  Main branch deployment workflow configured
-  Jenkins installed and configured
-  Jenkins Git integration completed
-  Jenkins Docker integration completed
-  Poll SCM configured
-  Automatic Git change detection verified
-  Docker image successfully built
-  Docker container successfully deployed
-  Nginx serving production application
-  Local application deployment working
-  `gh-pages` branch created
-  GitHub Pages configured
-  Production assets configured
-  React Router project basename configured
-  Public GitHub Pages deployment working
-  Live application successfully available

---

# 🎯 Final Workflow

```text
                    DEVELOPMENT
                         │
                         ▼
                  Local Project
                         │
                         ▼
                        Git
                         │
                         ▼
                GitHub main Branch
                         │
              ┌──────────┴──────────┐
              │                     │
              ▼                     ▼
       Jenkins Poll SCM           dist/
              │                     │
              ▼                     ▼
       Jenkins CI/CD          gh-pages Branch
              │                     │
              ▼                     ▼
        Docker Build           GitHub Pages
              │                     │
              ▼                     ▼
      Nginx Container         Public Live App
              │
              ▼
       localhost:8080
```

---

# 👩‍💻 Author

**Theresa**

### Project

**Brain Tasks App**

### DevOps & Deployment Stack

**Git + GitHub + Jenkins + Jenkinsfile + Docker + Docker Compose + Nginx + GitHub Pages + AWS ECR**

---

## 🌟 Project Status

**Status:** Successfully deployed locally and on GitHub Pages 

**Local CI/CD:** Working 

**Docker Deployment:** Working 

**Public Deployment:** Live

**AWS ECR:** Image uploaded

**AWS EKS:** Not deployed (cluster deleted) 

### Live Application

https://theresa23-2025.github.io/Brain-Tasks-App/