pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = "my_docker_image"
        DOCKERHUB_CREDENTIALS = 'dockerhub'
        GIT_REPO = 'git@github.com:velmurugansundaram/Test.git'
        GIT_BRANCH = 'main'  // Ensure this is set to your correct branch
    }

    stages {
        stage('Checkout SCM') {
            steps {
                script {
                    checkout([$class: 'GitSCM', branches: [[name: GIT_BRANCH]], userRemoteConfigs: [[url: GIT_REPO, credentialsId: 'github-ssh']]])
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
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
                    sh '''
                    echo $DOCKER_PASSWORD | docker login -u ${DOCKERHUB_CREDENTIALS} --password-stdin
                    docker tag ${DOCKER_IMAGE_NAME} velmurugan1412/${DOCKER_IMAGE_NAME}:latest
                    docker push velmurugan1412/${DOCKER_IMAGE_NAME}:latest
                    '''
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
