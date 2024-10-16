pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = "my_docker_image"
        DOCKERHUB_CREDENTIALS = 'dockerhub'
        GIT_REPO = 'git@github.com:velmurugansundaram/Test.git'
        GIT_BRANCH = 'main'  // Update to your branch name if different
    }

    stages {
        stage('Checkout SCM') {
            steps {
                script {
                    // Checkout the specified branch from the repository
                    checkout([$class: 'GitSCM', branches: [[name: GIT_BRANCH]], userRemoteConfigs: [[url: GIT_REPO, credentialsId: 'github-ssh']]])
                }
            }
        }

        stage('Install Ansible') {
            steps {
                script {
                    // Install Ansible
                    sh '''
                    sudo apt update -y
                    sudo apt install software-properties-common -y
                    sudo apt-add-repository --yes --update ppa:ansible/ansible
                    sudo apt install ansible -y
                    ansible --version
                    '''
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
                    // Run Docker container and check Ansible version
                    sh '''
                    docker run --name ansible_container -d ${DOCKER_IMAGE_NAME} cat
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
                    docker login -u ${DOCKERHUB_CREDENTIALS} -p $DOCKER_PASSWORD
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
