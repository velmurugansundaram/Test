pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'my_docker_image' // Specify your Docker image name
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
        stage('Install Ansible') {
            steps {
                script {
                    sh 'sudo apt update'
                    sh 'sudo apt install ansible -y'
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
                    docker.image(DOCKER_IMAGE).inside {
                        sh 'ansible --version' // Example command to check if Ansible is installed
                        // Add your Ansible playbook or command here
                    }
                }
            }
        }
        stage('Push Docker Image to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: DOCKER_CREDENTIALS, url: '']) {
                    script {
                        docker.image(DOCKER_IMAGE).push('latest')
                    }
                }
            }
        }
    }
    post {
        always {
            script {
                sh "docker stop ${CONTAINER_NAME} || true"
                sh "docker rm ${CONTAINER_NAME} || true"
                sh "docker rmi ${DOCKER_IMAGE}:latest || true"
            }
        }
    }
}

