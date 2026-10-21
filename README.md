\# Brain Tasks App



A task management web application deployed using a complete CI/CD workflow with GitHub, Jenkins, Docker, Nginx, and GitHub Pages.



The project demonstrates how a frontend application can be stored in GitHub, automatically detected by Jenkins, packaged into a Docker container, deployed locally using Nginx, and published as a public static website using GitHub Pages.



\---



\## Live Application



The Brain Tasks App is publicly available through GitHub Pages:



https://theresa23-2025.github.io/Brain-Tasks-App/



\---



\## GitHub Repository



Source repository:



https://github.com/Theresa23-2025/Brain-Tasks-App



\---



\## Project Overview



Brain Tasks is a task management application designed to help users organize and manage tasks through a simple and responsive interface.



The application provides a clean dashboard with task searching and filtering options.



The main purpose of this project is to demonstrate a practical DevOps deployment workflow without using AWS services.



The deployment architecture uses:



\- GitHub for source code management

\- Jenkins for Continuous Integration and Continuous Deployment

\- Docker for containerization

\- Nginx for serving the frontend application

\- GitHub Pages for public static hosting

\- Git Poll SCM for automatic Jenkins build detection



\---



\## Application Features



The Brain Tasks interface contains:



\- Task dashboard

\- Create Task interface

\- Search functionality

\- All Tasks filter

\- Pending tasks filter

\- Completed tasks filter

\- Priority tasks filter

\- Responsive user interface

\- Task management UI



\---



\## Technologies Used



\### Frontend



The frontend application is built as a modern JavaScript web application.



The production build is stored inside the `dist` directory.



The generated production files include:



\- HTML

\- CSS

\- JavaScript

\- Static assets



\### Git and GitHub



Git is used for version control.



GitHub is used as the remote source code repository.



Main repository:



https://github.com/Theresa23-2025/Brain-Tasks-App



The project uses two important branches:



`main`



Contains the main project source and deployment configuration.



`gh-pages`



Contains the production static files used by GitHub Pages.



\### Jenkins



Jenkins is used as the CI/CD automation server.



Jenkins performs the following operations:



1\. Connects to the GitHub repository.

2\. Detects new commits.

3\. Pulls the latest project version.

4\. Builds the Docker image.

5\. Removes the previous application container when required.

6\. Starts the latest Docker container.

7\. Deploys the application locally.



Jenkins runs locally at:



http://localhost:8081



\### Docker



Docker is used to package the application into a container.



The Docker image contains:



\- Nginx

\- Brain Tasks production build

\- Static frontend files



The Docker container exposes the application through port `8080`.



Local application URL:



http://localhost:8080



\### Nginx



Nginx is used as the web server inside the Docker container.



The production files from the `dist` directory are copied into:



`/usr/share/nginx/html`



Nginx serves the application through port `80` inside the container.



Docker maps container port `80` to host port `8080`.



\### GitHub Pages



GitHub Pages is used to provide a public live URL for the frontend application.



Deployment branch:



`gh-pages`



Deployment directory:



`/(root)`



Public URL:



https://theresa23-2025.github.io/Brain-Tasks-App/



\---



\# Project Architecture



The deployment flow is:



Developer

&#x20;   |

&#x20;   v

Local Project

&#x20;   |

&#x20;   v

Git

&#x20;   |

&#x20;   v

GitHub Repository

&#x20;   |

&#x20;   +----------------------+

&#x20;   |                      |

&#x20;   v                      v

Jenkins                 gh-pages

&#x20;   |                      |

&#x20;   v                      v

Docker Build          GitHub Pages

&#x20;   |                      |

&#x20;   v                      v

Nginx Container       Public Website

&#x20;   |

&#x20;   v

localhost:8080



\---



\# CI/CD Workflow



The project follows the following CI/CD workflow.



\## Step 1 - Development



Project files are maintained locally.



Local project directory:



`R:\\Deploy\\Therasha\\Brain-Tasks-App`



Changes are tracked using Git.



\---



\## Step 2 - Git Commit



After modifying project files, changes can be staged using:



```bash

git add .

