pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'my_docker_image'  // Specify your Docker image name
        CONTAINER_NAME = 'ansible_container' // Name of the running container
        DOCKER_CREDENTIALS = 'dockerhub' // Docker Hub credentials ID in Jenkins
        GITHUB_CREDENTIALS = 'github-ssh' // GitHub SSH credentials ID in Jenkins
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
                    docker.build(DOCKER_IMAGE, '-f Dockerfile .') // Ensure the Dockerfile is in the root of the repo
                }
            }
        }
        
        stage('Run Docker Container') {
            steps {
                script {
                    sh "docker run -d --name ${CONTAINER_NAME} ${DOCKER_IMAGE}"
                }
            }
        }
        
        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', DOCKER_CREDENTIALS) {
                        docker.image(DOCKER_IMAGE).push('latest')
                    }
                }
            }
        }
    }
    
    post {
        always {
            script {
                // Clean up Docker resources
                sh "docker stop ${CONTAINER_NAME} || true"
                sh "docker rm ${CONTAINER_NAME} || true"
                sh "docker rmi ${DOCKER_IMAGE}:latest || true"
            }
        }
    }
}

