pipeline {
    agent any
    tools {
        maven 'Maven 3.9.9' // This must match your Jenkins Global Tool Configuration
    }
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub') // Jenkins credentials ID
        IMAGE_NAME = "nityaom/mywebapp" // Docker image name (username/repo)
    }
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/nityaomnathial/MyWebApp.git'
            }
        }

        stage('Build Maven Project') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: '**/target/*.war', fingerprint: true
            }
        }

        stage('Docker Login') {
            steps {
                sh "echo $DOCKER_HUB_CREDENTIALS_PSW | docker login -u $DOCKER_HUB_CREDENTIALS_USR --password-stdin"
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t $IMAGE_NAME ."
            }
        }

        stage('Docker Push') {
            steps {
                sh "docker push $IMAGE_NAME"
            }
        }
    }
}
