pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'my_docker_image' // Specify your Docker image name here
        GITHUB_REPO = 'git@github.com:velmurugansundaram/Test.git' // Your GitHub repository SSH URL
        DOCKERHUB_CREDENTIALS_ID = 'dockerhub' // Your Jenkins Docker Hub credentials ID
    }

    stages {
        stage('Checkout SCM') {
            steps {
                // Checkout code from GitHub
                git credentialsId: 'github-ssh', url: GITHUB_REPO
            }
        }

        stage('Install Ansible') {
            steps {
                script {
                    // Update package lists and install Ansible
                    sh '''
                    sudo apt update
                    sudo apt install -y ansible
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    // Run the container as root and execute Ansible command
                    docker.image(DOCKER_IMAGE).inside('-u root') {
                        sh 'ansible --version'  // Check Ansible version
                        // Add your Ansible playbook or command here
                    }
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    // Push the Docker image to Docker Hub
                    withDockerRegistry(credentialsId: DOCKERHUB_CREDENTIALS_ID, url: 'https://index.docker.io/v1/') {
                        sh 'docker push ${DOCKER_IMAGE}:latest'
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                // Cleanup any resources, if necessary
                sh '''
                docker stop ansible_container || true
                docker rm ansible_container || true
                docker rmi ${DOCKER_IMAGE} || true
                '''
            }
        }
    }
}
