pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = "my_docker_image"
        DOCKERHUB_CREDENTIALS_ID = 'dockerhub' // Jenkins credentials ID for Docker Hub
        GIT_REPO = 'git@github.com:velmurugansundaram/Test.git' // Your Git repository URL
        GIT_BRANCH = 'main' // Your branch name
    }

    stages {
        stage('Checkout SCM') {
            steps {
                script {
                    // Checkout the Git repository
                    checkout([$class: 'GitSCM', branches: [[name: GIT_BRANCH]], userRemoteConfigs: [[url: GIT_REPO, credentialsId: 'github-ssh']]])
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image with Ansible installed
                    sh '''
                    docker build -t ${DOCKER_IMAGE_NAME} .
                    '''
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    // Run Docker container with a command that keeps it alive
                    sh '''
                    docker run --name ansible_container -d ${DOCKER_IMAGE_NAME} tail -f /dev/null
                    docker exec ansible_container ansible --version
                    '''
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    // Login to Docker Hub and push image
                    withCredentials([usernamePassword(credentialsId: DOCKERHUB_CREDENTIALS_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh '''
                        echo "${DOCKER_PASSWORD}" | docker login -u ${DOCKER_USERNAME} --password-stdin
                        docker tag ${DOCKER_IMAGE_NAME} ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:latest
                        docker push ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:latest
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                // Clean up any resources
                sh '''
                docker stop ansible_container || true
                docker rm ansible_container || true
                docker rmi ${DOCKER_IMAGE_NAME} || true
                '''
            }
        }
    }
}
