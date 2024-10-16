pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'my_docker_image'
        CONTAINER_NAME = 'ansible_container'
        DOCKER_CREDENTIALS = 'dockerhub'
        GITHUB_CREDENTIALS = 'github-ssh'
        DOCKER_REPO = "velmurugan1412/${DOCKER_IMAGE}" // Your Docker Hub username
    }
    stages {
        stage('Checkout Code') {
            steps {
                sshagent(credentials: [GITHUB_CREDENTIALS]) {
                    git branch: 'main', url: 'git@github.com:velmurugansundaram/Test.git'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE, '-f Dockerfile .')
                }
            }
        }
        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    // Tag the image
                    sh "docker tag ${DOCKER_IMAGE}:latest ${DOCKER_REPO}:latest"
                    // Push the image to Docker Hub
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS) {
                        sh "docker push ${DOCKER_REPO}:latest"
                    }
                }
            }
        }
        stage('Run Docker Container') {
            steps {
                script {
                    sh "docker run -d --name ${CONTAINER_NAME} ${DOCKER_REPO}:latest"
                }
            }
        }
    }
}

