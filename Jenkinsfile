pipeline {
    agent any

    environment {
        DOCKER_EXE = 'C:\\Users\\1crore\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe'
        IMAGE_NAME = 'brain-tasks-app'
        CONTAINER_NAME = 'brain-tasks-live'
        HOST_PORT = '8080'
    }

    stages {

        stage('Checkout') {
            steps {
                echo '===== CHECKOUT SOURCE CODE ====='
                checkout scm
            }
        }

        stage('Verify Docker') {
            steps {
                echo '===== VERIFY DOCKER ====='

                bat '''
                "%DOCKER_EXE%" --version
                "%DOCKER_EXE%" ps
                '''
            }
        }

        stage('Stop Old Container') {
            steps {
                echo '===== REMOVE OLD CONTAINER ====='

                bat '''
                "%DOCKER_EXE%" rm -f %CONTAINER_NAME% 2>nul || exit /b 0
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '===== BUILD DOCKER IMAGE ====='

                bat '''
                "%DOCKER_EXE%" build -t %IMAGE_NAME%:latest .
                '''
            }
        }

        stage('Deploy Container') {
            steps {
                echo '===== DEPLOY APPLICATION ====='

                bat '''
                "%DOCKER_EXE%" run -d --name %CONTAINER_NAME% -p %HOST_PORT%:80 %IMAGE_NAME%:latest
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                echo '===== VERIFY DEPLOYMENT ====='

                bat '''
                "%DOCKER_EXE%" ps --filter "name=%CONTAINER_NAME%"
                '''
            }
        }
    }

    post {
        success {
            echo '========================================'
            echo 'BRAIN TASKS DEPLOYMENT SUCCESSFUL'
            echo 'Application: http://localhost:8080'
            echo '========================================'
        }

        failure {
            echo '========================================'
            echo 'BRAIN TASKS DEPLOYMENT FAILED'
            echo 'Check Jenkins Console Output for details.'
            echo '========================================'
        }

        always {
            echo '===== PIPELINE COMPLETED ====='
        }
    }
}