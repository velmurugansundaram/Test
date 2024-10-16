pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'my_docker_image'
        CONTAINER_NAME = 'ansible_container'
        DOCKER_CREDENTIALS = 'dockerhub'
        GITHUB_CREDENTIALS = 'github-ssh'
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
                    // Update and install Ansible without sudo password prompt
                    sh 'sudo apt update'
                    sh 'sudo apt install ansible -y'
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
        stage('Run Docker Container') {
            steps {
                script {
                    docker.image(DOCKER_IMAGE).inside {
                        sh 'ansible --version'
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
